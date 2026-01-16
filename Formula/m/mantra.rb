class Mantra < Formula
  desc "Tool to hunt down API key leaks in JS files and pages"
  homepage "https://amoloht.github.io"
  url "https://github.com/brosck/mantra/archive/refs/tags/v3.1.tar.gz"
  sha256 "379894f36ef04a6b4e57e77112070e23dcc75569d1df98a8f128fe24a8b5e0b1"
  license "GPL-3.0-only"
  head "https://github.com/brosck/mantra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "999c55a42a047937fb47e7f438f93041c3fcff6295ca273ef1fb812626fba325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b327b97eb7cd1bed9e3cbbb8523501568762c1ab23b3b6f96a1004574d250ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b327b97eb7cd1bed9e3cbbb8523501568762c1ab23b3b6f96a1004574d250ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b327b97eb7cd1bed9e3cbbb8523501568762c1ab23b3b6f96a1004574d250ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad0307f0e619dcdeb51cf5ae48aa906e7cb1d97133beb064e506ebc47cf4aa0f"
    sha256 cellar: :any_skip_relocation, ventura:       "ad0307f0e619dcdeb51cf5ae48aa906e7cb1d97133beb064e506ebc47cf4aa0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80b6e994904283deff4964a708498d2123a11b703dd4b41ef419fe7dc884504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c37cc06e99d712dc61fcc3b708660da350183a0e3bb83bf1273c2c822ca324a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output(bin/"mantra", "https://brew.sh")
    assert_match "\"indexName\":\"brew_all\"", output
  end
end
