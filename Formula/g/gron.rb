class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.7.1.tar.gz"
  sha256 "1c98f2ef2ba03558864b1ab5e9c4b47a2e89d3ffaf24cfa0ac75cd38d775feb4"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ab0e3eca90fad344508e30b818ad21ecb6bd4f0995bde86d0d8b86e47cbc3bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856236ceb1dbc90437bd4a214ac5cbf9618ae17bb170f5187fc0acbd8110b174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "322c63263dead630c89ab151634b663ecf95d93a82034b3e5b75c42318912835"
    sha256 cellar: :any_skip_relocation, ventura:        "f046a622113661374c20ca12ba8e725f80bdf9ac1be704e3e7b850a0219e9e84"
    sha256 cellar: :any_skip_relocation, monterey:       "7b03cebd6d4120718aeb3de935087981d9e234c844df866076518417dfd6e9e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28a8bf800179d49a5aeb52d57bac6100eee9a5755c0dc112dc7fd7e7413323f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8422ab18406e6231c4731d0f124641508175c2ee142bd5bd0d99f1a97252c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10089d68a7958fb52643f3813b910fb5ab3a89ffb18d5161e5f717956b6bf2c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
