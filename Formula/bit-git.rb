class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.6.tar.gz"
  sha256 "eca7d63d3782a2d64f7cc6abcddff5fff2d87abf70eef994c32b6fe1f4a1fdf1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "545935e02014b4eac74fda0443bdec11d5b0746113e7c45bbf97fb3035b65bea" => :catalina
    sha256 "694adb25013317abfb363101953a5028561238190c3ef3134593337698913093" => :mojave
    sha256 "f5de0cc16a2db81240054929a0ac40e6298f37ba9e9255da79a4880c0ac54a2a" => :high_sierra
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
