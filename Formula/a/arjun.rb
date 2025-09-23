class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/04/22/c5b969720d2802de2248c2aac0414ee5ae234887cfe150564d591c73fb23/arjun-2.2.7.tar.gz"
  sha256 "b193cdaf97bf7b0e8cd91a41da778639e01fd9738d5f666a8161377f475ce72e"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b44e35f9b4e94b3d942a42f602d0d9a8d7ae430543aa661bcf4d8e1148ec71a"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ratelimit" do
    url "https://files.pythonhosted.org/packages/ab/38/ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9/ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dbfile = libexec/Language::Python.site_packages(python3)/"arjun/db/small.txt"
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET -w #{dbfile}")
    assert_match "No parameters were discovered", output
  end
end
