class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.8.1.tar.gz"
  sha256 "80f19e249356f6adc46071bbf2a01f139c0af9997bc3e323eb62952863d7cf8b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "85b8409f9012bfda02a17d27605063b4aa8eabe2a38522ae56325b8f4c423f15" => :catalina
    sha256 "d4c25d968475239933582206f9733164286f60b1c1d6a6229da15c954080077b" => :mojave
    sha256 "494b39c9402126019107c13b8e31a61b7354be7d42b58bb91e45574bb7c9d213" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args
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
