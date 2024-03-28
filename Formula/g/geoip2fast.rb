class Geoip2fast < Formula
  include Language::Python::Virtualenv

  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/eb/34/6d91d8165b2d717736360c65a7822ccb025bca4cd0a1385982c49ce73b9e/geoip2fast-1.2.1.tar.gz"
  sha256 "75bb4cd4931c245c5aaecdac7e2d2a350689e1dba4a1a5371eef92263995adb2"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e934ddf66eb8248eef8ec3e5912e3cd1e3ee52d98ed6bc99d0144c026fc44edc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4aab26d2ca133046f3272dd64d8d186d2fb7dce8fea6992ecd5809527a914dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77b58b066a3320da9f253d8ad7d2aefb39f88c70923ce61d09c125722869055"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0d24792a19b58e43ba3e537509f6ec6a8316a4101df064686236e3cd2d35c1e"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba2eeeddec130b5d2020145176b49c300a2e4a05e473eac469ac0bc3bd728a4"
    sha256 cellar: :any_skip_relocation, monterey:       "69684de9178d843d0a8576e7e8e269aa92235ddfc0e5fcda8319971ce4bf669c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d674f96b51e0a4254fa89be229ff494f97d16392432990dd0d7a24a8596337df"
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
