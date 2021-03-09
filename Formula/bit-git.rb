class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.0.3.tar.gz"
  sha256 "4557779eea05183e3e2efed3233db56ec2fa27bc82002134a83f0ba1dcfef374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62a8615987cccc28a3d89fe6e5045e4d482d629d5d35ff2a02d1007c04a5a834"
    sha256 cellar: :any_skip_relocation, big_sur:       "0006b168d26dfe3781c0bcf688b2ccd2ddc130e21527a387ef3aa5a4ef79b39e"
    sha256 cellar: :any_skip_relocation, catalina:      "18244cda0a8ff95f46899f1c88029a1a26c3aff6daee9769fceb843e75b61501"
    sha256 cellar: :any_skip_relocation, mojave:        "cb409436628d95f5c299c8cbe6207e014fc506543db77c53c91811dfb92c0753"
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
