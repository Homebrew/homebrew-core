class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "98d464041015c888c7b48de14ece5ebc6e410bc00ca7bb7c5a8010fe781f1dd8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655e862017b804e7b2fde1e2f17ffe6ef46aeb5a78420580f6a270c4d6848dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68463d104e1118065a6ffb81023e5cebed60b750da50619a789d85fda1b1802c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c06dd1736087586d1bb463d6ad4597dc37d972ae3c2e3f013e6bb5fda99f2044"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5a2cea26ed1d21502f6c6bcde42a6b79e65d6aa5eb03ad28d232bd6ffdb2da"
    sha256 cellar: :any_skip_relocation, ventura:       "f66dbfe9177e49cfdf6e3dce6d86cc67358e21f7381d0150e84085a4c36b9c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f413d9639e8721c355554b86e49b7ee7074fd7f8b8602089c6d9d1d0d919942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3043f3fabe0b6c0231cf4541cab6cf7637300bf377465c0b32fd635acca34f0"
  end

  depends_on "cmake" => :build
  depends_on "lowdown" => :build
  depends_on "ninja" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "llvm" => :build
  end

  # -ftree-loop-vectorize -flto=12 -s
  # Needs Clang 16 / Xcode 15+
  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "10"
    cause "requires GCC 11+"
  end

  resource "rocm_smi_lib" do
    on_linux do
      url "https://github.com/ROCm/rocm_smi_lib/archive/refs/tags/rocm-6.3.3.tar.gz"
      sha256 "679dfd0cbd213d27660e546584ab013afea286eff95928d748d168503305c9c4"
    end
  end

  def install
    rsmi_static = OS.linux? ? "ON" : "OFF"
    gpu = OS.linux? ? "ON" : "OFF"

    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      resource("rocm_smi_lib").stage buildpath/"lib/rocm_smi_lib"
    elsif OS.mac?
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura
    end

    args = %W[
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_EXE_LINKER_FLAGS=-s
      -DBTOP_GPU=#{gpu}
      -DBTOP_RSMI_STATIC=#{rsmi_static}
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "cmake", "--install", "build"
  end

  test do
    # The build will silently skip the manpage if it can't be built,
    # so let's double-check that it was.
    assert_path_exists man1/"btop.1"

    require "pty"
    require "io/console"

    config = (testpath/".config/btop")
    mkdir config/"themes"
    begin
      (config/"btop.conf").write <<~EOS
        #? Config file for btop v. #{version}

        update_ms=2000
        log_level=DEBUG
      EOS

      r, w, pid = PTY.spawn(bin/"btop", "--force-utf")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (testpath/".local/state/btop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(/ERROR:.* SMC /).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
