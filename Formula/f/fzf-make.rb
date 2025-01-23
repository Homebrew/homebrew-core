class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "364f6769b22377130d10fe3f8656a5bb1832b39ee6f0ed50cae5a00d72ba8c06"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b199d6dece7defd8fd60abce9aa3ee9b31c4626325f82d82a5e7b74db57decf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9148620a971bf96e234be8c5a4cf91221fc1d25dc2be5558020e2d38b02b1794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0fa5902949fd7fd653e1a3f50f38c74ca949e611f6e9683ee9660c07acf41d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8915cc6ad84209949036456f5bdc3e567cab2f0327c9a8ab8047b33435265cd6"
    sha256 cellar: :any_skip_relocation, ventura:       "05b9c3dc7006ebd8fa5491c8ad58c91f163213073bdb48dd759b32f1131f3405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc7c88a97bae9b516253b02a9175cb8e71b23b0efabc268c915e882b1962f8a"
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
