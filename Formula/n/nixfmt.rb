class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "e3ff9cbaedd90b0cb71c897f2e09542a3601f7ea6b6ec02f156405e5b8ea8749"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b7d9964f7d50d74fffc0689bf787203359a82186f0973df7e238dab8190c171"
    sha256 cellar: :any, arm64_sequoia: "97ee688b11b4300b7dd59fbf4ade5a10adb669eed7d4af8752b353eab1bcfa7f"
    sha256 cellar: :any, arm64_sonoma:  "a878a4382893a31d53f0c5c6cfcaa65ccbd7357a2162c1eefa44e05d683147b8"
    sha256 cellar: :any, sonoma:        "54904aef1d9a8cd827d3ff4d428423e9e12a780f1bd167b97bf69e068d1a9d86"
    sha256 cellar: :any, arm64_linux:   "547ee4926cfd41cd95f718a872e63ade591a0a97f0d841bf7f11df86f0cb3a59"
    sha256 cellar: :any, x86_64_linux:  "2f00cf388e09036ef20dbc248a40a4e3b882849dcc0c9adbae71e46065d3a9b7"
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
