class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.9.tar.gz"
  sha256 "f61217ad67a6b8ffb4c841ee64501df4e0311df50cd89cb716539fe8a47d41c0"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, ventura:        "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c771aad1b5711b2ce32cc470ddb608803c020d8368dfd61d1c679883e4c24ad4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
