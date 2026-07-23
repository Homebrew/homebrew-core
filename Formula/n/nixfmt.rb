class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "adc9a3174fe18333b6de5829f4b663a2736d6d78450e1f19270fc994b38a49aa"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "4bc09a889be21bf50d21f90c065343ce9abff3a16dc8bc557081d8c4dbe2a602"
    sha256 cellar: :any, arm64_sequoia: "2f1714d3e95253b5db0e7e1e5e94726bfc31c91a503bc6261a116a89718b4cbd"
    sha256 cellar: :any, arm64_sonoma:  "af3e982c8b8ebc1b5474ca52df344372890769e7224905b1610ae4b54a0a25dd"
    sha256 cellar: :any, sonoma:        "d01d0fc1833770942c10b5172ce7a2d1b2f66bebce73894dd39a87959435bebd"
    sha256 cellar: :any, arm64_linux:   "d312a7c5343d059110ad5c2cd53665ca6251a193bbefb638acb6b39fd9f28b88"
    sha256 cellar: :any, x86_64_linux:  "bbab822b83c7aa333ad74c8b9965dfeb8f1eda3fd7fa30415ba097a435e849aa"
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
