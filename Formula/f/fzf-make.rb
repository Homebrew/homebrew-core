class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "eb514511f30974722d78065de333549c7ece6f8d9d0d695e9b668a2aed0eda87"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15289eb53bc2d0f851f77827eff457af81d44497d77282baff1f6b18fb1b1048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e106bb7887ba857b84ef28094724a267281a889902f852f4ae5df55a5def247a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a68406b22a4d1d764c134680a2fa3a5508b1f6662b1c36c74194050f516f42d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e27e7e8ef04664254910cf93c32e61dbe2287061f2eba8fece25547e0d69f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b510b6b39957649a68eae5dfd93eaf8402988856e8ffc688c8b3bd411a0ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14ab0a1f49ce5ed9d6fd2b4e54f5181b9b9cd5f2cd73a44af7d347377dde728"
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
