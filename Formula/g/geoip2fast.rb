class Geoip2fast < Formula
  include Language::Python::Virtualenv

  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/eb/34/6d91d8165b2d717736360c65a7822ccb025bca4cd0a1385982c49ce73b9e/geoip2fast-1.2.1.tar.gz"
  sha256 "75bb4cd4931c245c5aaecdac7e2d2a350689e1dba4a1a5371eef92263995adb2"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee5174b2e9e4f372524dc72443f51cb98648551df011d519f47e333524ed03f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2466f0e83c3072bc75f9c11ed3f7cbfb9be50106d842b9390f91920695c890b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9428f558b1b5a293c2aafbe032264333e42b1477eaa33c9b8dde08f9751dcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd6f4dd07556771e26dd42bb01676f51118c402d36b1f38f511dd28b6566b0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "0a658876cf3f5aca6653d27b179115314ac57c925dd4b4ccb551e3adc4352f82"
    sha256 cellar: :any_skip_relocation, monterey:       "2787e8cc8d0c0ff4b5df98c7d8d580e16334c6b16d2814b8782867b5846084d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0402ff566f44c1f6f63c18bfeaae6410cd8716786f508c8caf0d331c5e2757e3"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output1 = shell_output("#{bin}/geoip2fast --self-test")
    assert_match "GeoIP2Fast v#{version} is ready! geoip2fast.dat.gz loaded", output1

    output2 = shell_output("#{bin}/geoip2fast 1.1.1.1")
    assert_match "\"country_name\": \"Australia\",", output2
  end
end
