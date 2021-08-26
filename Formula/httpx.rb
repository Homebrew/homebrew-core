class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.2.tar.gz"
  sha256 "78fcf67d143619fa428c04290acff5e84f8fde1a038c4348e490ef8834763f5b"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34fb1ac66b70eca6ee2ed453d4ef0693debf521afe620a3035c37ac2cb154913"
    sha256 cellar: :any_skip_relocation, big_sur:       "632528bc7b0aeb80b5aeb7c071447a64ddb64f26c615ae792df060cae4cbde67"
    sha256 cellar: :any_skip_relocation, catalina:      "1254a2235c1664c2486fea7631f02d8b238caf331c5bfc0ea103c8cfb25468ce"
    sha256 cellar: :any_skip_relocation, mojave:        "de1c33bba55e354643575cdc882c27ca82ed88cadc11908d09442e218199c502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102d35b81a64b1376999d107393093993212cbbf314e3bc1c2a90ee063af7d8b"
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
