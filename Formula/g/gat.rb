class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "9a7705691bce4b534184a970efed22fdd8d7ffcffca7fe90f4a294c5c49c1920"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b79d35a9d311044de7741eaeae7d74d6184cea0172f861c5d73050b0a6ebea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b79d35a9d311044de7741eaeae7d74d6184cea0172f861c5d73050b0a6ebea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b79d35a9d311044de7741eaeae7d74d6184cea0172f861c5d73050b0a6ebea"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d5ec6f6de1e475923b29acec9feede0b8c1a820a412bf25f425333309bf5f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da71ecc24cdbfe09d8a3374f0f133cf77082817618a26eb148e5caaca1a47377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd033d26d841b05923415f5facb56da575fd498509e923f2f6fa6ad23e53615"
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
