class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "614827e269ece8055904241675f691b47f5c6468604264412c4fec2ca92d3474"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "460e32c76bd3980229c081e9ab5978a62665a75e47169003673be1a0b3833c38"
    sha256 cellar: :any, arm64_tahoe:       "f2bc27a6028ced72ce3c017931fa619175eccfce5c34e2d35b71e030e3e35140"
    sha256 cellar: :any, arm64_sequoia:     "46e7efed8d5f8ede09cf847f026dc7608ffbdea6b58c5b9e07b68b3fbe31813f"
    sha256 cellar: :any, arm64_linux:       "8013f77d820a6647214be0042789f615cbf822128961e6b58c32a2284ccec23d"
    sha256 cellar: :any, x86_64_linux:      "9163b4c9f0283e565d60593ff3b16ce798c411761ef83e717c58d2316a462929"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_equal "nixfmt #{version}", shell_output("#{bin}/nixfmt --version").chomp

    ENV["LC_ALL"] = "en_US.UTF-8"
    input_nix = "{description=\"Demo\";outputs={self}:{};}"
    output_nix = "{\n  description = \"Demo\";\n  outputs = { self }: { };\n}"

    (testpath/"nixfmt_test.nix").write input_nix
    system bin/"nixfmt", "nixfmt_test.nix"
    assert_equal output_nix, (testpath/"nixfmt_test.nix").read.strip
  end
end
