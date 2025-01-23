class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9755ec21539ec31dfc6c314dde1416c9b2bc79199f5aceb937e84bafc445b208"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bb1be7ca5dfde3d92f8edf755edbd2cea4129c60730055612f4cd863a637252"
    sha256 cellar: :any,                 arm64_sonoma:  "21bbb2235762909ae76b3ac1222b183c5f2f05a8ae07b779001fd90e683b3d73"
    sha256 cellar: :any,                 arm64_ventura: "2667efc81b47fa5e6d8c157207f6c6a9f192066766b0aab1f6a4aed02b18e02a"
    sha256 cellar: :any,                 sonoma:        "6fae915b3b92936d1b9eb6a6ed584f7c0b64a86e032e33f0ffe4aa7ac9dce696"
    sha256 cellar: :any,                 ventura:       "5039e6dc3df7510c9a1fdbd3fa5d4badfcbf32da1a285e7d0bdf9650e8d03124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0f43ae1e6737997497dedf44a3de25a00de76f1a90a159f90acfaa2e890035"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"legba", "--generate-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/legba --version")

    output = shell_output("#{bin}/legba --list-plugins")
    assert_match "Samba password authentication", output
  end
end
