class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.1.1.tar.gz"
  sha256 "17e089162b8c0264e51024779a78f54b4eb413bfafdfba7d785725bf6a850a54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88e94b4cd23cd550799c1b11453605de5eceb68a22d8792db6801813f21731a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "26ff7744ac652a8054a58f849270e4fd5625636f302cec33f03d7b13e3d755ce"
    sha256 cellar: :any_skip_relocation, catalina:      "e7e8f345dc17cbe35589caf53f989b28b195c54948547fce012c388906a63eb4"
    sha256 cellar: :any_skip_relocation, mojave:        "9ca70681ef10ffedf8b495514744d762e970747cf4e7ba25235d34c52ff26779"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}"
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
