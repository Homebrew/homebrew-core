class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "818746d03e9027b55c592fea15375bef03f0b59a2158739a4917396a2b476003"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ded0d88ed29c6af0ad4875a7640519663f37e25e5e923c12fcf81d880513009e"
    sha256 cellar: :any,                 arm64_sequoia: "4b211b61de67f43bea63bc8b6f41051810fd93e7a047598f2305b8e2a7cd42bc"
    sha256 cellar: :any,                 arm64_sonoma:  "24d0785ae425f1096e662be0bd948c6edd5207d4b3d981b201faef7b1f40fd9d"
    sha256 cellar: :any,                 sonoma:        "c1e7686fa27a56b9079b05087ee0fa0a8f242d647ae278e6ecb5d7d1c6a62c61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ce5920d0f0f821e531adceba0e53944cca874c8d366641c098a242e19b108b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbce491b522c3775bc6ac974960e238bb2e92d3b0fd43ef5ce9f682dfded22cb"
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
