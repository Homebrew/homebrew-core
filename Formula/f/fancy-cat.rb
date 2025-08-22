class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88fc6d9e5e1dee81da8892ae277c43283bbc2ecf75ecc3ee33b1a98e9e7c3395"
    sha256 cellar: :any,                 arm64_sonoma:  "2e0a0d1dde99309144aa89e7a2fa3251bce4d2ab6987dfb2e8fd5c841eee33f6"
    sha256 cellar: :any,                 arm64_ventura: "125bb039546008da794a16341f58e033b6268bb257d5ab6845374728efabfaa8"
    sha256 cellar: :any,                 sonoma:        "910c30ec58e4134087836880bb8bdfc2d5b484587b671e3cf8623450f44621ac"
    sha256 cellar: :any,                 ventura:       "a36577a814b64b3bc3d39c5a6bfba9924211664d5e76f7e58fc88c2de41db175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6e9cd2991144b814732cfa84f4d9c145deb5b1fb3e33d2456d558fd31ebc32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f9903b3c1441a1fbe3b19488f197660f62a108cb05fe5c08bf9ff3832b076b"
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
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
