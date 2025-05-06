class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "5230ea1da29463a717974a70daacb3145c7ba4e44473e7b685f8b66ffb8cd235"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1313a3b143621bad711ceffbe4b6c6004e7d58fb0719af4794f1435c17000251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0576bdc5ab9827f9cee9eb73bdddf8ff0ceeee03d05f2a193f60d43455bfa64a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d113fdaac36dc998d60c1430f44e4112d1b3314a8b9ac67b84a9205901c3922"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4bb38e6b39867b0bf2a2d6c36bbd9dd763744dda942d6f70faef5edc381d86"
    sha256 cellar: :any_skip_relocation, ventura:       "63e60e3f8546f2b80187b5380695b38b33573967d28d97aed653aa7961b0a822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71ef1a0c560c7f4cfdbfea281846d27da6855cb046435b2a32b260efa746a59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08d8abe828e196924888938be0656c35d1943b217323aa7c69997c51363b3c7"
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
