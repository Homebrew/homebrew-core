class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.2.tar.gz"
  sha256 "1e358cdd4106bb70706f9f31c584d6bcdc3b240334eb7c5dafad294baee9dc73"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f8c1829700d0134ac7215bb9d15314ab2fdd29926b94adb7a0c5e17be0c24a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2fc048d2015036d71909c50593a530fd8e0e71d061c6d5595725d0d538fb083"
    sha256 cellar: :any_skip_relocation, monterey:       "e92a39e76d8d4dff87d337e9e9ad1cce84f0866b6ca09f150b62f08887d20df6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dbab874174bc8d9f49aef0f5796a0ee8a4ed3ebfeea064a198f525617ca57b2"
    sha256 cellar: :any_skip_relocation, catalina:       "04455f6af5bd044edcc1ecd104c252461c4f12ab62b7a7bfeee01a8a82185ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97bae33742d928affce5288169949f1c4bdf9a6cfd9b2f8b0254d9491588477f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
