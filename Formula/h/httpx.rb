class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "1f91fcda7ef7e547a252a8da3c54c0723528cab972cdbd274139b6f96bce60d6"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485abd90058d3300b485c1a8a404673e66b8924afd388e052cbd48dfeaa782ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8a644963510db3de117d5ba1560d7e912840da475c1af75ecc7a4139c94a50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e66c0ea7ed028ff6384e99465fbcf9855000884bc0779ded1b34c3b5e8e7729"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3cae1c7b9e7b154a1221db5f373eaade88640b516964d4fa2d35b02b2f4b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fbb04251e0ccce3028867ed07985ab799f71fe3e87edbb05e3aae265ef3864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8c4be6998108698577126ee4574c67db511131c5826069b75a0baa48dbeb07"
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
