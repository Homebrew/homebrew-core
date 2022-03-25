class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.60.0.tar.gz"
  sha256 "9b9deb8e42cf18ccf328833a4d051fc14cef0be468afc3b0dbde6657deb9f079"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b4c2b4217b6e57ac905fb4d5ccd01f023f2eab61a6fc48a591fc46752e4b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68375be184031009b9ba3f70f88329c4b30b01e2c33f7b7b5fb7eab2c3e9d877"
    sha256 cellar: :any_skip_relocation, monterey:       "d95cf2c196375b7a7bd7af0da22e67dafd99f7b751bbf73ec0dfd7fe2b4bba56"
    sha256 cellar: :any_skip_relocation, big_sur:        "44a3ae04dda52e4e50ca739324852b9f470345d4e5e72311e7ad861ec9c13eeb"
    sha256 cellar: :any_skip_relocation, catalina:       "d574f9a36d9f381e2dec16d19145653af8198b06a4b7c0a0fbc4875c8e54bdd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19bcbcbb435742a69e5806f09e5b8199fc224d70cfc218fdbb83965cb9a05c56"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
