class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.10.0.tar.gz"
  sha256 "b33d2975ba84a2c598dc1ab4c427edd40d25bcf2a3ca019d9582b60145fe8f5c"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "4158f5e110252f6e8bc4f9ce3974c5de1aa76b824fe28f41732e74da8f496b67" => :high_sierra
    sha256 "7b3d485743becaba9fbb4aa3a3a128d566bc2e6a59f1c6182a36458ec52bc178" => :sierra
    sha256 "0e99ce00467f8fb74396e7254df66a601987c2f8046bcc5fa1a7acf8cd5d3413" => :el_capitan
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
