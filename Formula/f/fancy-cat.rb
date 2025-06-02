class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "858207c07f258a550d2d97ddd34d25050370a3952a874e88c52fdcfae1367417"
    sha256 cellar: :any,                 arm64_sonoma:  "2414d4df19efcbf8b6ac444b51506001b6d5dc3569572e6f6735c6a3181421fe"
    sha256 cellar: :any,                 arm64_ventura: "b062e87e41ba0e891a04f6270889353e0693f744a6e20a1ed1a94f8d53d932d2"
    sha256 cellar: :any,                 sonoma:        "2ad1b39acc2edbe40af0b4aeb5878f5130c99fb0f109accafdd246671ab15b53"
    sha256 cellar: :any,                 ventura:       "09831309e4bd91134168aebe7ef9c052bba29aaa8b0958b950a1e71c55507fb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84ed2488e51c145f8eecfde84daf86889945904e05df93c1f1cadf8e8bae949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06e9a9771687070f658d364a241b312e79a39fad68edf164c396eb4b2f04109e"
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
