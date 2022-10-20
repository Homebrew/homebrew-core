class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "abea9ae6a7cd2d6874ac71d0aa429b9eab367daa4f301161a0671f85608216cf"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2432029ae7975ac5a0a24afb71079cf907524f13f1b08abd9c017dd041343cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b64aa082d9c10ea95b2f48c440cb0b7d407c983666c3b371d6e2e0edf2896050"
    sha256 cellar: :any_skip_relocation, monterey:       "72da594ab4e043847410ae11f7312130b7eeeabc29fdd5d4d9ca771dda553792"
    sha256 cellar: :any_skip_relocation, big_sur:        "218f3d8dac500e2af4a1f4f9a730017c9772f265879209fb76ca2808c8e9549a"
    sha256 cellar: :any_skip_relocation, catalina:       "218f3d8dac500e2af4a1f4f9a730017c9772f265879209fb76ca2808c8e9549a"
    sha256 cellar: :any_skip_relocation, mojave:         "ffea9a5b91b3ab12ffca3a7cb355ad973447e8c5f73be0331942b89ee0421f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3082e355aaeb672ded4fd24285bc2679d05d0f35ce314a9e02cf8240cc0240"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
    sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
  end

  def install
    cd "cmd/marcli" do
      system "go", "build", *std_go_args
    end
  end

  test do
    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\r\n=650  \\0$aCoal$xSampling.\r\n\r\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end
