class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ac0d2371bf69d5136de7e9470c6fb286cbee2e16b4c7a6d2cd48a14796e86650"
  license "Apache-2.0"
  head "https://github.com/aristocratos/btop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc8485b6b568348d6d5baad6b8683f7d4524c1c5128c2f4525d99c57d458c2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aed5321614a38bd8dd92b3a81cb171645baf433cb5710b805956b0e0ea9c1e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cfedfe5bab4746a667e6012323dd1e4457d00880cd9a60778d0a5aac0f2f70f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60cea9a8675c4fee4b3c69f5c6da46715e34ae5347f0b9a44edd82fd9758139f"
    sha256 cellar: :any_skip_relocation, ventura:       "caea296cb2d48dee3aefe6038a41a54fb6c1761dca20bd874a1f8dd83ef23663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf71bc7a9e5ceab6fda7308ea326590a21dd7690d966830483f55c8dc9db8c5"
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

      r, w, pid = PTY.spawn(bin/"btop")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (config/"btop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(/ERROR:.* SMC /).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
