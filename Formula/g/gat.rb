class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "714327c51cfbcd95162751cd8f062659af63cade649b1829eb3dfe7f716b28b7"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28515d63127e445194ee1c236290ff12260034ba8f144c10c6c49a1a4d60ea0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28515d63127e445194ee1c236290ff12260034ba8f144c10c6c49a1a4d60ea0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28515d63127e445194ee1c236290ff12260034ba8f144c10c6c49a1a4d60ea0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb387451e568ea11fbb4e0ecb565e2c338204db7256dea548baaa5364bc424ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdfd12c81bcce3dc3d2b268607f620adce9d59dfa9ef23fced97adcc5b0784da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ab1bc362bd7c1f21c3043718213293337064cd20b886898ca8052684b03832"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
