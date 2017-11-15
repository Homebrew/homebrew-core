class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.9.0.tar.gz"
  sha256 "165e8d0fb952883162fa1029ad20f28915d9be5cb751d5302805fa38df237764"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "e3932cd200ad1e87f892eb878eaf083f5fb35ae7ee448c263e35320e4a2d88b2" => :high_sierra
    sha256 "62fb3abd7c57927531cfd9280f077544572932c222b3ad672efdbbbb1236b5fb" => :sierra
    sha256 "21f9ace1fafc4924d57d2480d127e9dcbfab5fd7ace17cfde667852c42a198c9" => :el_capitan
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
