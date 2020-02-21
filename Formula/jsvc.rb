class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  sha256 "ebd9d50989ee2009cc83f501e6793ad5978672ecea97be5198135a081a8aac71"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "48de494acd623ebc41c0bbd998a3bebff6d68f663cfed8d9a341e67f6bf999fa" => :catalina
    sha256 "a22be457fd60e4dfc160b5fdb53e96fa3cb5f4c37aae21f588a5b764703bb707" => :mojave
    sha256 "86493fb043bc73a577609c4e1618505ba10a09110678217b9a7b5cf6ffb731d2" => :high_sierra
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
