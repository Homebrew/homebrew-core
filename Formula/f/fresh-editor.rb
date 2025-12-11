class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "23d8a25cab86f5a273587f98639de684cde3dddfe4321ef1b4c535499baa0e1e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c724103ee1b1978b430d22539b6afe1bd8b027b2f9757d26f213c00fbd53c6d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb16ab662394e799cf16febf0f2be44ce0ed51849a1437d99a948250c5dde5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360d2fd1510e9e3a0be4896e6a713cf291816c4026faabacda954f1176d6ec85"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b5935cac58570d14039008204120dcc28f47d729726272f76587d232271459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4049378a721f5347ab1e2f2c7db7124eba97ff8f41bb0872a4dd787c41c4984e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f58b062febf61ae4c65a01531fabb52ee98f5f24278869cea7fcd3e5287d40e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --script-mode --no-session test.txt", commands)
    assert_match "Hello from Homebrew", (testpath/"test.txt").read
  end
end
