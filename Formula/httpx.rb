class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.5.tar.gz"
  sha256 "0f0173aab9279c907991d228fad50aea28eba8e5c8e5c0b5adea7e09a0418890"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49f5fc7c8fb62842e036f6472eb0984b3f4bb48ad9ca261cf036bcc534cc5a0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fb826ba5b50342020967a632b6755e06f18d7c6849804b5dacbae58289ae3c2"
    sha256 cellar: :any_skip_relocation, catalina:      "42d5fe4c47e5d9f8e07043aaf46336e05a965c0980438c0c33b810e191807c90"
    sha256 cellar: :any_skip_relocation, mojave:        "bfccd9a888d28ddc135760dd3d783369709dff1c5f8f49bbc268edad8f5d789f"
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
