class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.15.3.tar.gz"
  sha256 "7fb0a43ff5e562089ca0ec3e8e7819dd205977758c02ea9bded05f56d5080a54"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77a548f2445ae0f437c39f122bed2f3e6150d88a5874741f2ee3293dbb53734a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4399fac618a6840eeaf82d092606d43578efe891b1178b8d4882c9c5024e49f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a29c33e8f195e34c51b3a4331818ca1d97abdf0f8d42422dc850d2a2ea4c662f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c6294c2eb05e1bf364953e014fa6da35c6d3a8a3f153db65db97af440027016"
    sha256 cellar: :any_skip_relocation, ventura:        "609eafbeb90a2610129c4d5769a22c3b7385d12711fe74b21b63bcd98d884c63"
    sha256 cellar: :any_skip_relocation, monterey:       "b6c20c64f44b4635c3e5d428bb31b3d3afa6760d6495eb68ff37a36d760bc1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dcf790d7d2ed5e00075a746134d8d0ba6998a5127bc50a58da5f8f34d11e347"
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
