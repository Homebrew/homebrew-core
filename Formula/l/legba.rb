class Legba < Formula
  desc "Multiprotocol credentials bruteforcer/password sprayer and enumerator"
  homepage "https://github.com/evilsocket/legba"
  url "https://github.com/evilsocket/legba/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9755ec21539ec31dfc6c314dde1416c9b2bc79199f5aceb937e84bafc445b208"
  license "AGPL-3.0-only"

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
