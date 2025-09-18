class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5e467a04218b6f56b359c1b509b5d00747a7b3d8bb3724f7e05bade4b0e9dd1"
    sha256 cellar: :any,                 arm64_sequoia: "a8b616881fcf93717070568139a9ecadbcafb63a63ca49fa0bf4bb8a4c0224d7"
    sha256 cellar: :any,                 arm64_sonoma:  "bae7dd4626af9fae45bee7cc39431c6ab73c200ee07095f8bb1379b6245b79ff"
    sha256 cellar: :any,                 sonoma:        "77783e9cdb049da391dfce37ef5045c2112153cda8c298ab222b2741507c5ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c33c5ec25345435d61d5db2cc7278d8621f0301b5fdc65b986a0a921f85666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ec808fa4326c738579b8f187f978546c495fb9503b99e66fd29e9e5504f79f"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-02-19", because: "does not build with Zig >= 0.15"

  depends_on "zig@0.14" => :build # https://github.com/freref/fancy-cat/issues/95
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
