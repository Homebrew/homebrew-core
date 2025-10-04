class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7191c8b6259f8124d2bef4c38ab0bcb7f13923dd84a6ec5cb5512f729765f5b5"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01aa0ca4e7e2b81e14e1d200a218662f2bcd2227ead80fdf4df367ff0e291d1b"
    sha256 cellar: :any,                 arm64_sequoia: "337ed75fc80e10d7f416002d2c4f9878f4ccdffc564ff37e187c5401c3e1ed22"
    sha256 cellar: :any,                 arm64_sonoma:  "033aa52fcbf033bf026c3770d5cc8fa0d6365f8d949278adb561a77aff370a21"
    sha256 cellar: :any,                 sonoma:        "ffcb005d8320ca631979298b966c26e944c720dc0fd5f0901653d63175b544f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd663ae4b8869b1133c332dd6e1a6e61f6ad4b36efd4570903279797f05272f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9480b244856abd76de765c4642aa43d8fe8f8212b20c8827013dfc889791784e"
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
