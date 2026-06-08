class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/1.3.0.tar.gz"
  sha256 "92707c3dfd809480714c2b5347d2f6506c8848466986597787671b9ffa8bc461"
  license "AGPL-3.0-only"
  head "https://github.com/evilsocket/legba.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b5ffcfb622129d9e1e4e15eb23c7f5d41fb299ec3abf804847258fa5bcf4603"
    sha256 cellar: :any,                 arm64_sequoia: "cc7a31566e35d829a6ff13fe615f6efaacd6221d0ada8968842f396ab82a45da"
    sha256 cellar: :any,                 arm64_sonoma:  "32723c6d82955620f6962a68727031f0b3b33ced6e973b410900259d1fc91857"
    sha256 cellar: :any,                 sonoma:        "dc4a48eb2642cc1c8dcee96f5b326f69074e658015e08b1b31b26feec732034c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9970fd099b0d1b6963fce8861fa80e828c2ff4c076c1c964ac11c4e734b0570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d0ffcc00f11eb2befb1c6a5a7a7b13fbf2b574ebe73db7a3821387a82bc12c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end
