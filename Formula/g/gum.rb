class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "b2c8101bb6f93acba420808df65b3f9acfe8cc9de283c1d9d94311123f43f271"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a422c6dc8e6cc18bc9fcf185f1787ad4058bf8aecaa9364c7089a7d3e48b1505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be74ddecc6b9d859db9af3e52f735f361370f629bc67f72e0498b672af0806ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be74ddecc6b9d859db9af3e52f735f361370f629bc67f72e0498b672af0806ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be74ddecc6b9d859db9af3e52f735f361370f629bc67f72e0498b672af0806ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec1cfefe01f777da9179c388be7b0dcede54f6130f303d9b7ec939e27deaa2fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ec1cfefe01f777da9179c388be7b0dcede54f6130f303d9b7ec939e27deaa2fe"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1cfefe01f777da9179c388be7b0dcede54f6130f303d9b7ec939e27deaa2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde4abc83877b129be0fbd048bcb9f57f8fa1c1b1321078d0787923b5fbd14f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
