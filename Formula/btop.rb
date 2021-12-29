class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https://github.com/aristocratos/btop"
  url "https://github.com/aristocratos/btop/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "f5e039ed235aaa24c7c7f8492043b6a251913ce8db688defc46aa83091d40ba1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69e3fe9db40a2199d27cdfc7a8069d91a9b6cefa17cfe16d724baca524675c3e"
    sha256 cellar: :any,                 arm64_big_sur:  "c157912f312710af3ad2fd0e085ae129cd25779171f71b63c7f09f5a065c838b"
    sha256 cellar: :any,                 monterey:       "d0a341938d3cf88ecadae9cdda08e9459f976ff69803206b71ac1bcb8590e969"
    sha256 cellar: :any,                 big_sur:        "4086644601c63cab3623b6c04fca98b64b59890fe5aaa7762e6ec5cb2e995311"
    sha256 cellar: :any,                 catalina:       "2c68f6617e40eca4e8214930cfc2e093b4d6791c5d40e1a98bc76fcdc5846d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b665fe653262fcfbcfd19868f60fc378c524a047d5062db8fa853ac8bd76794"
  end

  depends_on "coreutils" => :build
  depends_on "gcc"

  fails_with :clang # -ftree-loop-vectorize -flto=12 -s
  # GCC 10 at least is required
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    config = (testpath/".config/btop")
    mkdir config/"themes"
    (config/"btop.conf").write <<~EOS
      #? Config file for btop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/btop")
    r.winsize = [80, 130]
    sleep 5
    w.write "q"

    log = (config/"btop.log").read
    assert_match "===> btop++ v.#{version}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
