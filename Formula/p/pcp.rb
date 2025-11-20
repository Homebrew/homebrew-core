class Pcp < Formula
  desc "Command-line peer-to-peer data transfer tool based on libp2p"
  homepage "https://github.com/dennis-tra/pcp"
  url "https://github.com/dennis-tra/pcp.git",
      tag:      "v0.4.0",
      revision: "7f638fe42f6dbd17e5bf5a7be5854220e2858eb2"
  license "Apache-2.0"
  head "https://github.com/dennis-tra/pcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "04541e8deed7d35083d097a27b11789caacd0807c092a924bcfb20f926c08a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b70326a9568fb548f3ce008619104436192af8cd247f06eb722057d8188e828d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1aaac9b306226ce54909757ccdb10996d84803605c1e01f6f08e907ba7b30ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1bfa73d57867b1d14809dca455e97ebcb4cb36c67080f64f8a44b242719cf79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "127549faab2d9cb13ebd4ea2d7dfd17f0054776367769631b387aada1f7eacd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d495ee0f766c2d09355453d4f4691c7d5ca9bdf57ac82c0ef1d3552df19fefe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fddd434a5b6f469fd52bd804b85b4bad0f0814df4bc3f3e55b10534277c65d9"
    sha256 cellar: :any_skip_relocation, ventura:        "57e0f9db54f3539e0ef5a09bc957ca39e03fd8bd1db1764c47c06a13d7fc52a2"
    sha256 cellar: :any_skip_relocation, monterey:       "37aa1824b66b4581a3c2054c26731ee41ab757e3d768399ec43dedbfe2bc183e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fec012a0331f8ded437d4af20dd6ff527ca0b10ca8cfba73a40aa637358ec54"
    sha256 cellar: :any_skip_relocation, catalina:       "672ebdfce1cb30d596792cdc8652b1b2f00e19a66f9266a7796cf6b7b6d25a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7ec19afb01280000925b73e81a3ae8de97e7bc31a6bbd9b2b1403a674a7c3942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be128448d96fd7005c9cbda1c1ba2c71e7f7a58468c1c5bb3ec7a1f75c5109c5"
  end

  deprecate! date: "2025-05-17", because: :repo_archived

  depends_on "go" => :build

  def install
    # TODO: remove `-checklinkname=0` workaround when fixed
    # https://github.com/dennis-tra/pcp/issues/30
    ldflags = %W[
      -s -w
      -X main.RawVersion=#{version}
      -X main.ShortCommit=#{Utils.git_short_head(length: 7)}
      -checklinkname=0
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pcp --version")
    expected = "error: failed to initialize node: could not find all words in a single wordlist"
    assert_equal expected, shell_output("#{bin}/pcp receive words-that-dont-exist 2>&1", 1).chomp
  end
end
