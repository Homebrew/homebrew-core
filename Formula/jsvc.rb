class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.cgi?path=commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  sha256 "ebd9d50989ee2009cc83f501e6793ad5978672ecea97be5198135a081a8aac71"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3c40111cba2de0d7dd86e899db6e3e0f4a6bd8c1acfe376a6d7a4334f3ece3ea" => :catalina
    sha256 "875fd0c3ec60b81e46a09fa7874e16d10431f08b21f5672fe14ffa7cc6a0d174" => :mojave
    sha256 "40a4f7b1ed3195ff9de7a6aa9842e05614482c1ae9c8f43aad9afd0ebe90e009" => :high_sierra
  end

  depends_on "openjdk"

  def install
    ENV.append "CFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "LDFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "CPPFLAGS", "-I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers"

    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
