class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.5.tar.gz"
  sha256 "0f0173aab9279c907991d228fad50aea28eba8e5c8e5c0b5adea7e09a0418890"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aef5709cf5a736198839a50ded0bd5dcd66e49288c198592e7a6d6d8e9655b7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef305ebc0d2d351d38db6a0ded45bfe9bdef4ac5e3ba475f68eef2e985cf3fca"
    sha256 cellar: :any_skip_relocation, catalina:      "514fea44fbfdbfe8e21c7ebd4f4f9b20e854c5077924c9576236c210cb61eda0"
    sha256 cellar: :any_skip_relocation, mojave:        "595784ab06f9bfc22e3049eb7afb50db35abf47175330d6e751b95efab9713d7"
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
