class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7ee0ea5e0edd73e1ac7155bf9d3579f20818384ba1dc12b5a87f869b00a1ca69"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb0a95935f271f962992e6f43e93ee35c99fbf2df448f3402fe62ac82b3df23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb0a95935f271f962992e6f43e93ee35c99fbf2df448f3402fe62ac82b3df23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdb0a95935f271f962992e6f43e93ee35c99fbf2df448f3402fe62ac82b3df23"
    sha256 cellar: :any_skip_relocation, sonoma:        "317456f0bde6e76ee7c5821b89d1b4a287e0de7cbabc518b9f0dd1ad53300923"
    sha256 cellar: :any_skip_relocation, ventura:       "317456f0bde6e76ee7c5821b89d1b4a287e0de7cbabc518b9f0dd1ad53300923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fada42d788bad3096365c973f332eda26bb847f05c1f309d8a457555759641a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a837e4814951cdd3857ab52b5a6bd2e0036964d42434edf830ee9df8ad107e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/marcli"
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
      sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
    end

    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\n=650  \\0$aCoal$xSampling.\n\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end
