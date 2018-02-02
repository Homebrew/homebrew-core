class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.11.0.tar.gz"
  sha256 "5eb997639d5303c51ab45c7b23c2db7f5a5bafffe5a5b17803521528bef7e92b"
  revision 1
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "4115ca0aca8a87ddf1d4830f2f3e5c1096ba0ff11e57ded5407f18e18026d533" => :high_sierra
    sha256 "fccf2980f10b742f0c16c2e72f68e06a4ae827d169790ccb1a6e40781a0ebc90" => :sierra
    sha256 "062646631516636e38c2906eff35c22e155cd6c5421dacf72943e8d637c3f532" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :java => ["1.8", :build]
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
