class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "15289ce536e734767e06816c6bb33537121c3b70c2ecbc3431afe95942bb0fce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b80a23bdb952439fad84f5959c6f4a2f94aec1f81d9bdab508f06dffd3dc48b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3dfe5e07e6cacf856319636cd3710c81b653f01db144eef6a9555a1408969a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca96b2e33beb27cdc74279defcc05a6106f16230a7a084288ad473f85c47d1e3"
    sha256 cellar: :any_skip_relocation, ventura:        "618b3a235cef60980f3fbc8dfb8e577cbe22d9057ec312c007ac3d030257262b"
    sha256 cellar: :any_skip_relocation, monterey:       "3f6443263f440c504315c364192f56ac074494e97f6a77cddfab22849e7846b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eab9ac8774aed888835eca3d06113e46849049b05878d6e033bcd08675b2988"
    sha256 cellar: :any_skip_relocation, catalina:       "260cdb570c91a3cf31d14d37137d1fea9eddda146bd8d65576566efe2678cdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a52f7cff86590578aee5018ed10ecb35366300db0c65a318132e4b6f18c362"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
