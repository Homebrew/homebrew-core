class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "abea9ae6a7cd2d6874ac71d0aa429b9eab367daa4f301161a0671f85608216cf"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli"

  depends_on "go" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/hectorcorrea/marcli/main/data/test_1a.mrc"
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
