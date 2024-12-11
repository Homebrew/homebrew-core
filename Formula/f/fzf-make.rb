class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "275fafd5ed2d9e7f9d08af44f61259b7d57633c6039c3ac8a407e005530ed2c6"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95a74e9f06c9f12dda9d489e9d87b4bc8ad1a336b02c89dfd2b5d4d02c06b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2d81999305134224064736c48492866c0cd7130f68fb5084db0b2c73330983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d9d03f827e9cc00b560b1de6692edeb1bce430f86184f30fda16868f350f1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d971ea8454c8a56845d0e7ea63d17ba47368f8ce71bdab1eec57288f78c41e"
    sha256 cellar: :any_skip_relocation, ventura:       "290cc31faf41a589964968b285702acbafce2e1f5e4b2c7b6dad0f9042f4c4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b01f081f7cf02c57976c3b600f2da5f644e657a19e9bf2be47f1882e3c9d53"
  end

  depends_on "rust" => :build
  depends_on "bat"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
