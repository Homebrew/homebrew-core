class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn & just"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "9180cd307891aa36647d64c2eaaa492850e15c4af035086c7465cfcf0a1fa362"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3850f3f10ed072ca5a32632d8ff30facca0a1451fa7985b0d1457a62ecb26a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d96bd0af5ed0ad7f926520a65af855f1d015d126c20246d67a27f73722ce398"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "436207deec610aeeff7bccb5474bf4367a79f4c60c244732b5047f7631d5e5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77618dc381dd4d3ddb894d0b731a0be9d00defa91cb9ebc494e6b29ff91b91e"
    sha256 cellar: :any_skip_relocation, ventura:       "77cf7b11497455cccee8aed61b63b772d90b5e1f4d02f501837fe72f87083b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74abd65d3fa1ada9db6bfc3def38fe0364d2c579657e5407966b3155949a552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0a033a910b3821c5ae3b38e0ce872b6df1f5263d1512598f34f10fd774b8b3"
  end

  depends_on "rust" => :build

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
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
