class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ef7ac03db1469f3cd3b769a5749d38f0ee8d2363b08498878bd99da10642940"
    sha256 cellar: :any,                 arm64_sonoma:  "fcfe81ba4b2a801a19cd035c040a0d2b55fdeada2f79594284889e9d2cfad1f5"
    sha256 cellar: :any,                 arm64_ventura: "d67b651c6ec7d1a71f81862ab4bf956bd287bae99eed692a88217e385b378faa"
    sha256 cellar: :any,                 sonoma:        "3b9a2e5f33fa251b5f00481a7bc0cdb530dc8f315b4391d9051fcf316aee3349"
    sha256 cellar: :any,                 ventura:       "49c4f4e30c5693768bfe046210ec678b7fcaf1f674cfd0411ef29fc3f6fbf3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b051dbbf24bea369b3eb1a11d7ca2b659372c75a32df1c9025a27ae8a6bd2e"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu # See `zig targets`.
    # Cortex A-53 seems to be the oldest available ARMv8-A processor.
    # https://en.wikipedia.org/wiki/ARM_Cortex-A53
    when :armv8 then "cortex_a53"
    when :arm_vortex_tempest then "apple_m1"
    else Hardware.oldest_cpu
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
