class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "a3b5d0fe880dec4417f5078b93ad808678168d0edd418cc6e0489b982a97cc58"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ea84506c6e8ddb2a743ad9371f176e2d6b67a8e7b0bd71b0cae9ef442e8d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57458915484dfb96450a8804ef3ae78cff3b6dd8cd11e9deaa82896b6be18b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f40bc205a87839b5f70567c4e304eab489b6b616cef5d658951cca6ee74c735"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d91df66f9a99dfc5d99cfd144bc3b212e394976a8211108623e239217cba39"
    sha256 cellar: :any_skip_relocation, ventura:       "92f53ffc30bcb62763e44a989e8bc33e28e9b621853e8e0b2fb21be01406f863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1e1edddd90f0a94226712f8e551998b4306548e7f9e2cde29e119f416f16e8"
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
