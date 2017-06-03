class M3utoxspf < Formula
  include Language::Python::Virtualenv
  desc "Java based command-line utility that converts M3U files to XSPF files"
  homepage "http://selliott.org/utilities/m3utoxspf"
  url "http://selliott.org/sites/default/files/utilities/m3utoxspf/m3utoxspf-0.9.1.jar"
  sha256 "5282a30483fa01e474c51361567ddaf6c0076271cfc9c5c91c23121a85930b04"

  depends_on :java
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "vorbis-tools"

  resource "eyeD3" do
    url "https://files.pythonhosted.org/packages/72/91/e29d0d9d0df60e087b43188fc9c91256e6edb322a85719c360fb096c5045/eyeD3-0.7.11.tar.gz"
    sha256 "2788f09d6ddb98ac71c30f02a260ade7eb3198cfcb6d6be9b1a5c20d95bb043b"
  end

  resource "test" do
  	url "http://www.jaymze.org/proglang/media/m3u/myaudio.m3u"
  	sha256 "3cead02a8b5d8e5e4e63d5da3b260c108f50c8450d233f4b0038b442b519486b"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install_and_link "eyeD3"
    libexec.install "m3utoxspf-#{version}.jar"
    bin.write_jar_script libexec/"m3utoxspf-#{version}.jar", "m3utoxspf"
  end

  test do
    testpath.install resource("test")
    system bin/"m3utoxspf", "myaudio.m3u"
    assert File.exist?("myaudio.xspf")
  end
end
