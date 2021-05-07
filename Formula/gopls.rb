class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.11.tar.gz"
  sha256 "a9c31cb023bba0f7c751ad9d280723307235c895eb9f6f24fe17495d1af21500"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "122dba5330ad463b15b9e3ddd25ee61164d9c83b2958f52f9bee97599821150c"
    sha256 cellar: :any_skip_relocation, big_sur:       "72fdc3f10bd2771b269e8fb277ad1b9c58fd87cde1b7af5f9d3e53cf77462e5c"
    sha256 cellar: :any_skip_relocation, catalina:      "a1adc4624d2c66c278dc3c5ebf457d988363d92eea9a88e444b9dc4cc6d789c4"
    sha256 cellar: :any_skip_relocation, mojave:        "af7b08c0cda0b07364e6a92d104782827aa9ea45f463a51aef3b52e317a5c763"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
