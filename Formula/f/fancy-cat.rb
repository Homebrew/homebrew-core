class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "bce101d5eb009ec9057f7b87f6ad767ee96238abcee8854a9db7febd0229a2bf"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c58a78244bc3fa2960e7da1fef67cb37fa95044de6b3d18c71f21d09acdc9a82"
    sha256 cellar: :any,                 arm64_sonoma:  "85ed09ccf93cc98a5bee963234cfe58d73f40425124f5b2e548e6eee48b97d50"
    sha256 cellar: :any,                 arm64_ventura: "0f10abd85dfe9b4a4cdbed1341ceca7793d97f792477752a858c9d139e8d5198"
    sha256 cellar: :any,                 sonoma:        "74333ba909b6af5f78d3f966ce3a2f44a215e3016feda09f8cdc29e3db0a5620"
    sha256 cellar: :any,                 ventura:       "0a489a3529ffca4c283680fe3ac734d614fdea54d66696fbefbc7a06c24ae604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae039db5bcb1d98c058aedf2616c119ad51e6dc2d025a54eab28c79aff0733d"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
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
