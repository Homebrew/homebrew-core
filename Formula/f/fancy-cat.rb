class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d264dbaf05f8713a4c52ce0c74a8d5e900989ec815fac1bbfec7d7b385bc1dd5"
  license "AGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2916710816a7c6f26820f96b5197afe396803c59a4ed40f9e1c98c2d9650627f"
    sha256 cellar: :any,                 arm64_sequoia: "d7a14bcd27acbee4918e3b7c81079d4370ae86cbeed1cb5ff598e69fc52c6d68"
    sha256 cellar: :any,                 arm64_sonoma:  "7e9ca4ded1da91a6517e5d5b2dab7a8b323ccdb775302a756f3a76c22a99c7ae"
    sha256 cellar: :any,                 sonoma:        "11b2a4f1cf3190165cbce922fd750ca939e3fe265bf55c7a097d47e4c93fad12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "779a835c2b4e0e97ac50b4a111e8b7ee46e3c3f995410926cb758d8e089feebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb50aacc13177038cc20a489d91ea27794f2124f48860e1cdf887dce363f60f"
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
