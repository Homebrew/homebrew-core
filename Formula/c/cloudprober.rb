class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "5ee0bba29d64ee49eefcefc9e4dee6df279c34215729178265fbee2b200311ea"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c97947dba9b84101a023ce05deff40acfe1009fe728903cdb812b806d9c42660"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f413b97ae229ec976166ad6f4e45fb299c98276ba70743bb8cdc3c8233a7b377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1de19b3c679273a05b649c2f869f89f3bfa0ecd4f06e2019ee1a64ada27e12a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ea2f1dd53a8ea0613260df64e2a6e8579bffded7a405a32cda9a45b9856320d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7064b827ac1644a9a5d7d63a634bb5786aacb7dfa0ee565f986f994c8551459b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
