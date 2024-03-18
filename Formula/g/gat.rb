class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "62c7509bee419f81af5d2f856f17ec98d65dd12212b3e361806cb2b6a22233b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c706cfca8fd5af977a4b8e46a4aba3b69bb2c3f1e6c7c7ddb11d7d580d00e9eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3d4cd3c096edc481df4fa8f6b99294b44e7cdaf562190844e59af476bf52fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fc22c92ad185bc6fe0e92de23913b5cd72337eeffa1525bee9ca0243c46140d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9e6f4136cd6ffa504610bbe1fb0774329c541da744a334976bf9ca5149dcb3d"
    sha256 cellar: :any_skip_relocation, ventura:        "e6cd0720ac894cbbc4f6ef10d03935a2bfacd37004fb1b5f00aa9bd01650356b"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f18d4bbd3a6cb11c209aeeda5c7740b7d33ca72e8792df43e024bfdef25d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f5f14eb5471d4dfe1c7f0097e0a1c72ce2004c85ea0a96327efaccc2f3f826"
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
