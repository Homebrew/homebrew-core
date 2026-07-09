class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "adc9a3174fe18333b6de5829f4b663a2736d6d78450e1f19270fc994b38a49aa"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e01ade990f0546f933c2440ea93f5597c149d137201cc7688814901bd149f79c"
    sha256 cellar: :any, arm64_sequoia: "a5547dd233c6ff96c9eb1b8efc0b8b358030115fd0c5db499e998f941fb4b7b0"
    sha256 cellar: :any, arm64_sonoma:  "63c3771bc765ebd25e7838f104434cf9dab9ae2fbee93a51ae229ae4b5fcb95a"
    sha256 cellar: :any, sonoma:        "50276739120a99a5113ef7056d1cff3858c57025ff3f330532d94e7b50bf6e6f"
    sha256 cellar: :any, arm64_linux:   "1876e0c096027f2843cd2b5040cb2329a0108cd95888053e25ada024fb2519f4"
    sha256 cellar: :any, x86_64_linux:  "2b436f56071e88a83a2e212a8566a1bc81a2447465feb295ac415d3e668b97bd"
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
