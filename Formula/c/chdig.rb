class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "5ddaa1d326179fffd3cb2ecdacc3ba88f65decd4bd623c7fb094d5ebbd9f869b"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^chdig/v?(\d+(?:\.\d+)+)$}i)
  end

  depends_on "rust" => [:build]

  def install
    system "cargo", "install", *std_cargo_args
    system "#{bin}/chdig --completion bash > bash-completion"
    bash_completion.install "bash-completion" => "chdig"
  end

  test do
    # Sometimes even if the compilation is OK, binary may not work, let's try.
    system bin/"chdig", "--help"

    assert_match version.to_s, shell_output("#{bin}/chdig --version")
  end
end
