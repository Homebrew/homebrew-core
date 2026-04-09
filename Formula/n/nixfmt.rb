class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2b148abdf3c2ae9fca2b5898709cde5e4474e09cb32b892da51651c479f1f73a"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b71aff03f7696495f6aeaa305421f0e462be0c0b2562e6d5db82cd185e9a683e"
    sha256 cellar: :any,                 arm64_sequoia: "0c2088b203f4106a6b4b1ce9a22a3708d69b7a9337c5d078c00ba67d11c3134d"
    sha256 cellar: :any,                 arm64_sonoma:  "922ac0db5eb171679585614a696f207fa7e0d364bf533b476613d647af84513f"
    sha256 cellar: :any,                 sonoma:        "44a612a71f335bc9596ce3186977f9921b1357520777f4a0c0254559727ebf76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fbbe3f5a299fee9dd1ebb269f8a0224547245625cb249bf44f52d7e4a71b8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e25fd4284efa455be202300498501be2098a8bed7f6ea7e831902b2c5b37706"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--allow-newer=base", *std_cabal_v2_args
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
