class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.2.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.4-src.tar.gz"
  sha256 "5c2e31a7c1198ade5034d625ea10353cdcc4b6e99b84ed7fca4040e3df3339db"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "50894019268b0cc6757fb62da6756fbfe92138f79afa4eb363f0e14df81de9d4" => :big_sur
    sha256 "771e112751eb5c424f61c04f9a4aec6c02e0001ce88b400565c7a2b8fce71a51" => :arm64_big_sur
    sha256 "2e4c9e5eaf94ec1b3f9bc70288ea4dc4459e766dbc0f4df9c018f3bbdbf62456" => :catalina
    sha256 "357dc6a1c7e9f7c5e07263e0e9985ed3e2a578e9319289479ca204f7c10efc8d" => :mojave
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
