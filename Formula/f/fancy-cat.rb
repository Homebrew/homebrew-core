class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a782f6d82306d567b3338fa7c17ddc1e2c6bf74795048b1eaf4bfb7603fc1ecd"
    sha256 cellar: :any,                 arm64_sonoma:  "41e6dd06c7bd3bdbc7ccad87cff698abaef3301e7c68acefbd6d3af375254c49"
    sha256 cellar: :any,                 arm64_ventura: "3b7a36bbd3fa04377d38a2d8d53ff152fa72e7035f474d4488f5fed0b25a2ea9"
    sha256 cellar: :any,                 sonoma:        "8f22867da83fdcfe061c727ad1e2a4bf590b30590c3c2ce093438db046a8fada"
    sha256 cellar: :any,                 ventura:       "03bc6dded2e7c54c5965a9ab95e0eb59999f0d5f6ac936d623e9d8bdfea403f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2621a788dced301c41c2319f8633dad12e2a313563f5e3433d926132f37aedde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8cf3a4328817817e4288beb8ff21862341d0312231ae3759b29872ac969e4f"
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
