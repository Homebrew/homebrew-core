class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.9.0.tar.gz"
  sha256 "165e8d0fb952883162fa1029ad20f28915d9be5cb751d5302805fa38df237764"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "c9ab89d9da72c69bc09ccde3fd5b382a1399f99d8c701a1af4c552559d21a582" => :high_sierra
    sha256 "1b10d7452340503190531911fc569fd2f9eac3fc36fda912760fa2005ee03d3d" => :sierra
    sha256 "24cf292e7a14a0206a5e3eefda19df50a84767a2a7d0aa1294cb8b43d0ad6578" => :el_capitan
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
