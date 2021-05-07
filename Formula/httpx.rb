class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.6.tar.gz"
  sha256 "bfe25ca0984c1384a6ae99a926f9ebcda863dfd296472a43b5cb2f65b20673f8"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68f6e09a6d8f547c71fdeb48c7c9aa3034d2839aed5b4f9e2d3bd66555b3ea3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "855f4fd67c8c9004bd945d3fbfe58b7973d596d6aad68fb1ee37d1f7db9677f3"
    sha256 cellar: :any_skip_relocation, catalina:      "0ce82793697d8ce3af8ddec0ec8fb1f0f6385d5c19b7147ae1351d7f07aae435"
    sha256 cellar: :any_skip_relocation, mojave:        "eb7bb678b52874d1cd0555acdc01c4e6404ad3e4974b893cf920859e9f32770e"
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
