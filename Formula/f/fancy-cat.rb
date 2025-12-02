class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7191c8b6259f8124d2bef4c38ab0bcb7f13923dd84a6ec5cb5512f729765f5b5"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa2247970af16f34db31eadc37f2786a9a2537f6acfc189964d0bcc958a6b370"
    sha256 cellar: :any,                 arm64_sequoia: "21c9e586d933128219b54a09ac691959a2838d5203fde9dc9d83ab9339d5012e"
    sha256 cellar: :any,                 arm64_sonoma:  "1e526a3efa2e6fc1dd81bf1c1c45ef01142fee28264f770650e6dda0890421dc"
    sha256 cellar: :any,                 sonoma:        "86f0bc6ac7fea7f0532473630c1d3225b47f6b10fb1d1ab5686c8cf1a4ab98e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84ca60d2ffbe19ab8111306dacf60a6f57f5881980adf95117cdcbb65634fbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "490e0fe47479e56fd48e416c12375fcabb7f72df1be684dde1015e91b0afa5f0"
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
