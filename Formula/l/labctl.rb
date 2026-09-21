class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.112.tar.gz"
  sha256 "3579988a92e6d75ca94c4ac4a58b92a791d0dfba87e146f5a32cdd7bb0c2a170"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07c8394bc77209baacd5668b227996cb3659d5fdac4bb1f135db5bf8880a93c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07c8394bc77209baacd5668b227996cb3659d5fdac4bb1f135db5bf8880a93c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07c8394bc77209baacd5668b227996cb3659d5fdac4bb1f135db5bf8880a93c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "07c8394bc77209baacd5668b227996cb3659d5fdac4bb1f135db5bf8880a93c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa9a18503e9ed0fea6194775e7f0ae5831896bdaacc561a3a14dbc4b6bd51b8d"
    sha256 cellar: :any,                 x86_64_linux:      "170b7798d20394e344cef99d1cb25ba0ce877885c915f22ecf912291730de61a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
