class Pcp < Formula
  desc "📦 Command-line peer-to-peer data transfer tool based on libp2p"
  homepage "https://github.com/dennis-tra/pcp"
  url "https://github.com/dennis-tra/pcp.git",
      tag:      "v0.4.0",
      revision: "7f638fe42f6dbd17e5bf5a7be5854220e2858eb2"
  license "Apache-2.0"
  head "https://github.com/dennis-tra/pcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1bfa73d57867b1d14809dca455e97ebcb4cb36c67080f64f8a44b242719cf79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "127549faab2d9cb13ebd4ea2d7dfd17f0054776367769631b387aada1f7eacd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d495ee0f766c2d09355453d4f4691c7d5ca9bdf57ac82c0ef1d3552df19fefe"
    sha256 cellar: :any_skip_relocation, ventura:        "57e0f9db54f3539e0ef5a09bc957ca39e03fd8bd1db1764c47c06a13d7fc52a2"
    sha256 cellar: :any_skip_relocation, monterey:       "37aa1824b66b4581a3c2054c26731ee41ab757e3d768399ec43dedbfe2bc183e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fec012a0331f8ded437d4af20dd6ff527ca0b10ca8cfba73a40aa637358ec54"
    sha256 cellar: :any_skip_relocation, catalina:       "672ebdfce1cb30d596792cdc8652b1b2f00e19a66f9266a7796cf6b7b6d25a9f"
    sha256 cellar: :any_skip_relocation, mojave:         "d5e48f3b7f8e0e0034dede947f94b0d5a23311e6ced60093b2cdfea9427389e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be128448d96fd7005c9cbda1c1ba2c71e7f7a58468c1c5bb3ec7a1f75c5109c5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.RawVersion=#{version} -X main.ShortCommit=#{Utils.git_short_head(length: 7)}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pcp/pcp.go"
  end

  test do
    expected = "error: failed to initialize node: could not find all words in a single wordlist"
    assert_equal expected, shell_output("#{bin}/pcp receive words-that-dont-exist 2>&1", 1).chomp
  end
end
