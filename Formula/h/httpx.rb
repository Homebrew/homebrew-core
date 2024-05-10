class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d7a2fad5c85057faba622684269c9c2ffbf8859abb2f6bc4e73bc8c1483b2852"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45851f20dea36bfd496f8b068b7be00fd74c1dfc2f407dac76326c4b5c619757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c586d15cc9e00947b77749923d65279ec1c7e87715682ec286c2c50aa0b96dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a69dfacd102c6a359e40288fb9a84e9d6854e9d42f8da7240cf6095f8eabbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "abd637bf633c389d30422430362844123d9744268ceb90e4ab003e664f0e4d06"
    sha256 cellar: :any_skip_relocation, ventura:        "5d64b17dbc06d4c2601e6a0e92e3cf01e10864bff81faa11a406b785aa9b48a6"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2442f1780bcbb92777aee0182fb8c061e986bc278fc9014c623cdcd24de585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bcd36d7a9cbc9b6d5c634b7e40a7347e1a50a9ecfa960b95f22a5f094d762b3"
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
