class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.4.tar.gz"
  sha256 "e0a06e1504e10a51c6009751d79b798c98d8274e559fe195d4b4b7ddadf91bb8"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dfef144aa6e632941c194fcef6041ec76982db39fdc2397278e8a60475fbe66b"
    sha256 cellar: :any, arm64_sequoia: "51f9388c7e07708388d48b0a823081661c6a5678f49a6051d0d0f6bf024130fc"
    sha256 cellar: :any, arm64_sonoma:  "fe3b49e760e4b0b82b4473a848554a73839f884322cc60de0ddf0b8703ea1c16"
    sha256 cellar: :any, sonoma:        "0dc3332b90d0f8811016f213af86af542b6c22d8944757de29faa45b85123dbb"
    sha256 cellar: :any, arm64_linux:   "40a5438b93cf240a5c751d969618195746762349c05bb7d2445e4ba27e2c37d2"
    sha256 cellar: :any, x86_64_linux:  "de0c0fe6e6459f251daded1c355c37d1133bdf866f9f7f656f77ee6489b73d36"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end
