class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "7c7ec037dbc99610796f198699dab6b82d0d39588e3581bbb57fac0b9f575523"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "738acec590a04d63cbb6d241c89da61fe5b00962e922cc704766da0c2516a2fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "738acec590a04d63cbb6d241c89da61fe5b00962e922cc704766da0c2516a2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738acec590a04d63cbb6d241c89da61fe5b00962e922cc704766da0c2516a2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e500c045d5427a40c8be1e9b37d52bf9311b419916f86e4035c3a3216152af2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "282d9f6c428be1ccdf88a6ce4862341d27f252636dcca1ffd150ac272354a5f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2f3403e22b28b22f6404fa3aa87bb94176c03ddef00aa05a88f24a0467758e"
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
