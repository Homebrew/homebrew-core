class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "98d464041015c888c7b48de14ece5ebc6e410bc00ca7bb7c5a8010fe781f1dd8"
  license "Apache-2.0"
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

  depends_on "lowdown" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  # -ftree-loop-vectorize -flto=12 -s
  # Needs Clang 16 / Xcode 15+
  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura)
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
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
