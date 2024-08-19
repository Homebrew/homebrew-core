class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.16.1.tar.gz"
  sha256 "0805bb9d3bfa51334b4d45a3182daea3e77ecbe27f4ddc672841ec72f63ed20a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af86ee6cf93a8666e2f0572d6e161d2133513a184fcbb9d28fd238d5cb415c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85f5b3ea2807379962554d963ffff07ed778c3cf9b21acf76b74bfc0c3208fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278e33bcf2ca501759948770303f141fa8df2899e479531889c2e40190c16bc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca91d403b3b2e214b5c0977dc630d361eb77174503a129cb3e5831498fc67f05"
    sha256 cellar: :any_skip_relocation, ventura:        "f2215bb94906681c166db96aed6cd5000eef23c881680c5dc9ec64c6b9dcbf1f"
    sha256 cellar: :any_skip_relocation, monterey:       "50b911c8deefdbd694c5a00f4ad3d28280079d2c2a6bcbeb73943a30ef1e683c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918229b1da008c7ec402d500b24d1a959509df7f34d13a651440a997739fffb3"
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
