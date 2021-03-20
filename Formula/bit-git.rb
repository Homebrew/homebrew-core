class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.0.5.tar.gz"
  sha256 "e51648df68ef2d4e7628bb266ab43f9c75d851d28788b5111255aa338b94ce1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "687fc0b96f9eacceec5dba5014397eb5a9fa2efad47a770914df65a34339921b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1c634bb430bb01cf111ffcf136482751af401d9cb9c6542b2f7534247c53f38"
    sha256 cellar: :any_skip_relocation, catalina:      "06c1ee6d6ddfc04c8e40524a46dc70e0adb866fbfa6d4702dc1055b430c3a72b"
    sha256 cellar: :any_skip_relocation, mojave:        "b9ed1472241f09279f4ff6371d04f91263fe118d6349173173434ec39609c23d"
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
