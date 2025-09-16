class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f91e09f6c1cb3411d3c673032ebbe0f06ae87f1428add02cebec10e080f15369"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fba4a894b95176d38a067dd25c96c27c24d59aa966406fb2a8f22f791e0323d"
    sha256 cellar: :any,                 arm64_sequoia: "a567dd22a8efbdc8b1f4f630cf2136fa483178d50a05b9ee514f87e2c56cafa4"
    sha256 cellar: :any,                 arm64_sonoma:  "2b3d63bdd233c9bbcd48af30dd461e3a295d6e537690f27fa048730aa5550dcb"
    sha256 cellar: :any,                 arm64_ventura: "0c59ac82a04449e01a61ea4e7023beb51d7ad05c5b5e24148efdc2c4141efda4"
    sha256 cellar: :any,                 sonoma:        "44c8e8e19e4a38cde001adbf0c6d5c89c87528f5f95fbb59dd6a352403f2a173"
    sha256 cellar: :any,                 ventura:       "5cf5df5111472befdc3589aa20c700219575fe81433ae26ed6f7ac52a0902ea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "438de159b30484830799d5a02539e62ae9c8f78337d59e6463462c338e825768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cbd063abc7c0dfbbbcf327135cc7dad0594470fa19c27542fdb1aae789d4f9f"
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
