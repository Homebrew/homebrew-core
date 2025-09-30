class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "37d3c700d288d8beac3e6685d23a6034de5fb10538691dc53f6c679a26e76fb4"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829c048778054b22f4db890f78cbd3f75fde925f026e0b81b9200085e1f1aa5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635d21a45cf09356c46b9851b7de92b6fd423278a99e787287745df69a17587b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9924c37da9b37b9cde0f7216a50b9cfb605535c713e26796138e8deec5c7d316"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6800c2f7cc58f98ef6944b344949e758e60c10ddb5d21055c09e0939ec656a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5391a580a4d148ffc763b027fee2c3c4f2c5909a96dd6f487f0db3b3b14e2d58"
    sha256 cellar: :any_skip_relocation, ventura:       "24ce8d5ebf223fa8c46262f7cc22f059ae641b045bd523a302113d16c1a5f13e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "264985616da42cca2e4bf09669a82ab41739d1b6be1fd3dd187169930f287492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d90ab7d9d70bf77574b54a5ce39f874a17fbf3a0874dfc0b5010c8c493f85f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end
