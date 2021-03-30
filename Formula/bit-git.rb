class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.0.6.tar.gz"
  sha256 "f8713cb122f2e301cdd3f9af7a13cb90f84fd2db778652c77d9faafe83ca9e28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92d57255318aa5e9c5582a94a3abadd981db148d44dcd423abca07879d4440fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "1af005d928b0054578e44f65f9af1a0a97ab65e06f47ef9ab90eadce90c3a30c"
    sha256 cellar: :any_skip_relocation, catalina:      "8fcd251aae64b0c73e105197f33ea407871413e426815f9c6730624256a3667f"
    sha256 cellar: :any_skip_relocation, mojave:        "950e2c711a110838317688310280107aea211c629f403b80aa598649109dc401"
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
