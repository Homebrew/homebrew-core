class Erlfmt < Formula
  desc "Automated code formatter for Erlang"
  homepage "https://github.com/WhatsApp/erlfmt"
  url "https://github.com/WhatsApp/erlfmt/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "c7205f3a28dac589c623f21546d63d5b04cc669545d03485cb88552de0117f43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c4afe0a977c263dbf3a3092122de3ddc8b6a78f04a483eac966efa7da3ab04a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e46dcbc2b217c649af757a08c6412491ecbbfef7281b98def97be8f2153da1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f6e918c0ca3428813215a8b3e3a44f32980d220169e954b9dccb1d9ed8851b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7405e9ff053f412bfb1b04ef79f34cd714e0f385849dd3c4352272ee65a6845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c423008872616122b6436941c0d2f8fdf8954afa573d313f19a14b5525852a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ace846773bbc50b1ad7e69fad8bcb55976484c6628eb87986cfc968e02f94ad"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "rebar3", "as", "release", "escriptize"
    bin.install "_build/release/bin/erlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erlfmt --version")
    assert_equal "f(X) -> X * 10.\n",
                 pipe_output("#{bin}/erlfmt -", "f (X)->X*10 .")
  end
end
