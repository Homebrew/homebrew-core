class Nixfmt < Formula
  desc "Command-line tool to format Nix language code"
  homepage "https://github.com/NixOS/nixfmt"
  url "https://github.com/NixOS/nixfmt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f91e09f6c1cb3411d3c673032ebbe0f06ae87f1428add02cebec10e080f15369"
  license "MPL-2.0"
  head "https://github.com/NixOS/nixfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a22eeab4edeb24bca9533b16d61aa17bba0d478077b6b3623020e5240b39faff"
    sha256 cellar: :any,                 arm64_sequoia: "0cb4cc5728426485caa065bdfab846ecb9b8dcd64f2312905feb63d0ce86ea3d"
    sha256 cellar: :any,                 arm64_sonoma:  "eb428e2c1d99b767f1afaa148eb4fc9c29f51bd143338aa82518011473ae9dff"
    sha256 cellar: :any,                 sonoma:        "bb3989e5362fb7ea41535f03e485b258ac4dbd1b992309ede2a4ac964911412a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93526a1f2d5efe39db04df97ea5627cf5cfb80abb1b0d7cb25d3fc8825aebbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710696be949ad466a1353790eaee09946551190e4bbe423b4a7f41c2d22cdec1"
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
