class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "9cac96d8bc942f70d1f9d05432b50e9c6d3d0d46aa3f153093d3c327b4eeec2e"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ee11a54fa86a72684c3dd967482de43c5f739fca7391ba3b48a509db44d43b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9172e9c040e4bc4b2c18eb422d03bafce92018fbfb1045b80761b6fb9136899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2c2b8f3363f28d2cd2f566e3b462e862f54237cdf9e39a13b51c6a8188c1274"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaa4ef215679d5d78d9be773f54eab2230af3a251211b56bef572cb026f96ad2"
    sha256 cellar: :any_skip_relocation, ventura:        "f96710225709855ab3a843cdd737f29a4a53960de0b3c533e9a629f80836819a"
    sha256 cellar: :any_skip_relocation, monterey:       "f332adacf4491d91a7cf363e6f12c2e645ea85696fb6dbe22f1f426e09cda8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edce851a950a7548f3f469d6585efcebf9bd5371cb576fd5c8b8d2e12b527de1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
