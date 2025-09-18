class Cai < Formula
  desc "CLI tool for prompting LLMs"
  homepage "https://github.com/ad-si/cai"
  url "https://github.com/ad-si/cai/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "af2080ff5bdca09a26db9f6b809b5a480b24b75a833622832ca022e213fd5173"
  license "ISC"
  head "https://github.com/ad-si/cai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bec82f6cf5bf77aa553f1f9ecfb5cf63840dedcdf3393e2885f5818e55d8aa72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6819ef2cd130e83a98ec23101d4c2cebd2fd45b52ef5d015e15a8b18ebb04a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69abed5efde26e64f867bd8fdd7e428f5f611fd839a48cc6f45df78a16331627"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d7292bd88ae5b997ea3e9cd01a838210efd4b1d9ae39c601265c81f24bb984"
    sha256 cellar: :any_skip_relocation, sonoma:        "44732608ba49fac105865075d4d85c79ed0551a4728e440f4f59933f8fca28ed"
    sha256 cellar: :any_skip_relocation, ventura:       "36a90f28a6668537a7acc45116a6c54de5d209110c6e0cd83d588473fcade6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9057ca47aaeec34d15170ab08263d63a6304150677bb7b8d369111601b0ab2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234ed79f33a701debfb463ed91b1a6843f8a728bd700a98b157994e947fd2a1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cai anthropic claude-opus Which year did the Titanic sink 2>&1", 1)
    assert_match "An API key must be provided", output

    output = shell_output("#{bin}/cai ollama llama3 Which year did the Titanic sink 2>&1", 1)
    assert_match "error sending request for url", output
  end
end
