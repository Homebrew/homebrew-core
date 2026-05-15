class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e2b3fcdda6fa0564f47fb3dc5ce06729f0dc9532e538bb847dad1e684f545e4b"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a866f596b657e9767f18ccb6662f0140a030991ad2bf4a4ca4eb15febc910820"
    sha256 cellar: :any,                 arm64_sequoia: "08150e5234950a8396d798dbd9bc570a368d421a050688c05898bc9ec631957c"
    sha256 cellar: :any,                 arm64_sonoma:  "b801a9ef49f818cf25141f208cff0baef2a0d65518d159428f0daee1e3f9435b"
    sha256 cellar: :any,                 sonoma:        "4511eb7a9ef917c8eea3fad6488c93c7db468442842794fbd2b1fe2275a679b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ab652310a0c3d980648ef0565c44a782e2b6dda87e7b3c5d9a5d0d8adf2e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26198ee83287fa56bee15edace4c0a166cfc64b3c3ec17b41dfc746b3d823ef3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
