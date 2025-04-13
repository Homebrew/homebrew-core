class Geoip2fast < Formula
  include Language::Python::Virtualenv

  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/c6/07/2a346a6a3294e1a1f6c1852f17ae555160d6f41d8636ea00c2ae0a89a8ec/geoip2fast-1.2.2.tar.gz"
  sha256 "38815700cedfeb197d51b4b8733b0d4f7965b36de15147c125527124f8b45d6b"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d93a6fa3fcfd371c0c30898ae03dff0c17a78860b8eab97ff7cd463f737478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d93a6fa3fcfd371c0c30898ae03dff0c17a78860b8eab97ff7cd463f737478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0d93a6fa3fcfd371c0c30898ae03dff0c17a78860b8eab97ff7cd463f737478"
    sha256 cellar: :any_skip_relocation, sonoma:        "0852cbcf23ea45b65d8f25f50baa8b233a1323388d4b344a2ed02b604db596d0"
    sha256 cellar: :any_skip_relocation, ventura:       "0852cbcf23ea45b65d8f25f50baa8b233a1323388d4b344a2ed02b604db596d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cac968bc1355949b10d0e9f2f3f23e410c5cb8af6f86bd107f286cf3fba405b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d93a6fa3fcfd371c0c30898ae03dff0c17a78860b8eab97ff7cd463f737478"
  end

  depends_on "python@3.13"

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
