class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.10.tar.gz"
  sha256 "92f70967f4fc4b95b26bf012d46d71ae9c9a0a46d7324c20d498f1141c1b8225"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf6df37854f450c7d0622e1246b5b0d6aa2cc5f7510107a3daa1ef0f88869629" => :catalina
    sha256 "84fdd113b29ca76d4e7947ed79dc1c7bdd718a3a513c78d7bec873661c80f1a7" => :mojave
    sha256 "55119d9e450bf7392ec531d82b166eaf200d33fef1bc5b258577554e7c6792fb" => :high_sierra
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
