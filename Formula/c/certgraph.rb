class Certgraph < Formula
  desc "Crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph/"
  url "https://github.com/lanrat/certgraph/archive/refs/tags/20220513.tar.gz"
  sha256 "739c7a7d29de354814a8799d6c5ce4ba2236aee16ab7be980203bc7780769b47"
  license "GPL-2.0-or-later"
  head "https://github.com/lanrat/certgraph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bb875c3150d6b112b81aa2e8fdec0393f8d1c62a052ccd53b4349550559307c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87984362d6fa214b3adad55d4ee28ecf6f102e5fc3dc62f0f85b186210824518"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "303c6039381a5d9dfe1865103a5242c8ce6260a9391d02238c1a52051707538e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b5fee234dd83f986f53ea5a8491b82fa6a7eeaa9d2f598e26aef1023395c99"
    sha256 cellar: :any_skip_relocation, sonoma:         "36aa352a0a7ae8f8abaaa9507371211218cb4d81762a063e31502fae2f50444f"
    sha256 cellar: :any_skip_relocation, ventura:        "50ffe0bc271d347b26e0fbabe4ce36403c50a275eb020254940db32557d26c88"
    sha256 cellar: :any_skip_relocation, monterey:       "4d76930426da0cadfd8bef3e8e60c26ab291dd5aa83512fe336f7461d6ffb3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9651e81f791eeeedca90abb0cb4330fd8a22b77a1649e143d665071c7916d6ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitDate=#{Time.now.iso8601} -X main.gitHash=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/certgraph example.com")
    assert_match "www.example.edu", output
    assert_match "example.org", output

    assert_match version.to_s, shell_output("#{bin}/certgraph --version")
  end
end
