class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli.git",
      tag:      "v1.14.1",
      revision: "b3f6be7babc4e05956d0b7988bf7b3465bd25ad3"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "747bcd10a215cfb81f29d14d8bd8208c8218e0fb4bb5045369b692c97b749012"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5adfadefc3de04f401bf1b5423e1b4e2d7c84e348dfc7f814030759cd0502a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b709967795c22f77d6af0d5f5bc85e05855e882f69d3b09a729baa78dc20998e"
    sha256 cellar: :any_skip_relocation, sonoma:         "92a8d885f5ad9ee6ff7157bedbcd40d1a42880b9479796b5e26e557b50d59720"
    sha256 cellar: :any_skip_relocation, ventura:        "18acf70a037745d2e0b77558c5e3f95221ff42b0338bfcaa3b62db58ee084466"
    sha256 cellar: :any_skip_relocation, monterey:       "f48f57c2b7ec7e1a41523255e5e6654cbfcad2b63f3ec9e6e2d6e9062dd20712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6758afc226615f5e4fc85d2abb3ae6a757c096c11b96c1799858b9d3afbf8c31"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
