class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a701bbfd37f493909b68c5f13cc3802c1468eb1b291fb4aa955dd6dd4ee9c82d"
    sha256 cellar: :any,                 arm64_sonoma:  "604b4f4a8a68c7f8405a00930543dbdda592f5939aa8d4ffe16f0868ba3d0952"
    sha256 cellar: :any,                 arm64_ventura: "9e2ee80fd453a54fe9dfcb0b7670ea9540719eb292227c84a66f995542ffc8b6"
    sha256 cellar: :any,                 sonoma:        "da434a308c5403ea201190114504160310061026bf7bc773b5bbd73baf139e24"
    sha256 cellar: :any,                 ventura:       "b1e3e63dad0d297dfabe58a21dff30ff6167612ec6a7fd063c86374f42082b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b388b4d8664618f95007db25995a26d3ea03a5a28243168af333cbf3ca34b592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8553d25dd61c2ff312bda88e9a468036749be2c9d34bdda45afc1d452c88688d"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application, unfortunately we cannot test it properly
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
