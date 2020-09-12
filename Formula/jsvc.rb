class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.2.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.3-src.tar.gz"
  sha256 "37b8c461c52e76c1ed6cd290431237611dfe496df36cd70e5afa30659d9bce4c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "688f9f436c8756240df9877d1e7af2d3830d1d41ccd774808649ee18ad18dfad" => :catalina
    sha256 "f31981563a96e74b21ce270bd84b063246fbbd9586e70b35ca6c9400733322ab" => :mojave
    sha256 "c819329bd3ab04fad7fafc13e7deecab8c704864ff967825c3c552e21782a714" => :high_sierra
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
