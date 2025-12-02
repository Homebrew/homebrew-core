class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "00f85aeb7d4e8ac098cd535c7400de9d1f1b5153a2346283f6b8292b816a3408"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b1b3d82819e4a2693f1c22ec973b419ed7b6af473987f044775e3b5d272cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d864e72ee4c2a3614dbc75e717a07b24d484fdc241989e9eb95190cae4be8e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac36a1c123ec412060a4c13e6b500722f9a8bb371f04e779f103c20e9a497fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5a59a263dda617ec7000fb7fbad8b2561ba359e0c4d714f017fda387c592e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b78cebbe9f95b9feaac8c89d127e8d4ba2ae59d583333ac823d88fda77feeebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e0704ea80d91ec63cf7f63349d24e1d5d974449a8e59c9532e00709c5a2d25"
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
