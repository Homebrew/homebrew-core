class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.9.tar.gz"
  sha256 "aeed18396ad2a12c3a4c60b6a248c16b34b3f71e52958c45bf6d7d17ee6c3007"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ca334755e7f5e61db20a5dc52a636a297b33b7bdb4f3c3f7547998bd86abb26" => :catalina
    sha256 "ffcefc3c17f5695e2f00d8ac4e0c107aa8b6115412c78a1fa4317572ab89d7ed" => :mojave
    sha256 "2d018589f911ce954202cc01a4358c991dc4b4fdb1823f1eb39677b18cb2915a" => :high_sierra
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
