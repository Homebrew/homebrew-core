class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "1c98f2ef2ba03558864b1ab5e9c4b47a2e89d3ffaf24cfa0ac75cd38d775feb4"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c889681fcb82d04bc59b80fb2beffb61f61794bff3dbe0145454559639a0d7d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8b0537d08cd5b8c60d561cdf84c3f9a2c51006506c36b4a5f54f28b686dd33a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597c9c6fc6cdf0006dece77e1954e5112ebb2d61d996fc5d2273018a634a3ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ab0e3eca90fad344508e30b818ad21ecb6bd4f0995bde86d0d8b86e47cbc3bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856236ceb1dbc90437bd4a214ac5cbf9618ae17bb170f5187fc0acbd8110b174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "322c63263dead630c89ab151634b663ecf95d93a82034b3e5b75c42318912835"
    sha256 cellar: :any_skip_relocation, sonoma:         "98148084bf065904b2a75f4dc7b94982f09a277c62cd5e0d843918e6fb022f4f"
    sha256 cellar: :any_skip_relocation, ventura:        "f046a622113661374c20ca12ba8e725f80bdf9ac1be704e3e7b850a0219e9e84"
    sha256 cellar: :any_skip_relocation, monterey:       "7b03cebd6d4120718aeb3de935087981d9e234c844df866076518417dfd6e9e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28a8bf800179d49a5aeb52d57bac6100eee9a5755c0dc112dc7fd7e7413323f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8422ab18406e6231c4731d0f124641508175c2ee142bd5bd0d99f1a97252c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e70945d74b90ca9e8cd455764ba671b2d25408c4548ff5fe99f97ede13e07d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10089d68a7958fb52643f3813b910fb5ab3a89ffb18d5161e5f717956b6bf2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal <<~EOS, pipe_output(bin/"gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
