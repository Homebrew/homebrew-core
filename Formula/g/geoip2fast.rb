class Geoip2fast < Formula
  include Language::Python::Virtualenv

  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/c6/07/2a346a6a3294e1a1f6c1852f17ae555160d6f41d8636ea00c2ae0a89a8ec/geoip2fast-1.2.2.tar.gz"
  sha256 "38815700cedfeb197d51b4b8733b0d4f7965b36de15147c125527124f8b45d6b"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f06fa2b901560ce2690032b5cfba427793f529f506f9099a1e1bc33c0e7ed72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f06fa2b901560ce2690032b5cfba427793f529f506f9099a1e1bc33c0e7ed72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f06fa2b901560ce2690032b5cfba427793f529f506f9099a1e1bc33c0e7ed72"
    sha256 cellar: :any_skip_relocation, sonoma:         "5127a366a1376cfe0abbd7e30769894519c06a2fc6c35f4af5d73a728280b97d"
    sha256 cellar: :any_skip_relocation, ventura:        "5127a366a1376cfe0abbd7e30769894519c06a2fc6c35f4af5d73a728280b97d"
    sha256 cellar: :any_skip_relocation, monterey:       "5127a366a1376cfe0abbd7e30769894519c06a2fc6c35f4af5d73a728280b97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd411f0f9b0e302f52a70d55360867f1cc77b5b04485d109f147bc3381de2b4f"
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
