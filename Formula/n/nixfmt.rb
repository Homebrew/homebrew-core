class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7feef8f70f2f565c5fae54fa5ca99ca9dcc80603d593386885117b78ee6e04a3"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d373613d9e5347e722ee05880bcb062bfdaae1bc6ec8c7801ece89bd192764ee"
    sha256 cellar: :any,                 arm64_sequoia: "77aacbc49e2be610768d8dfdba87e3eb0e2b72ce0ad9e1bed50b401e1ef66632"
    sha256 cellar: :any,                 arm64_sonoma:  "f9022748f44c472d48cf51e18e9c5c9d1dad9a0d74fdbe1b4bfb06b96abe3fbf"
    sha256 cellar: :any,                 sonoma:        "4a0bfdf2df6b2bdbe2c8219bd96a7ece1f797ebe18f405b8b377adbc711eeb2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3882c4283b966bc4bf7ce4c2a2513ebc602d800fcf04cd7b5ef9370d0f58aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b57857acee4f03b8ee5be8499bd2c465b0eac166ddb08029628aa2e9ab070b32"
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
