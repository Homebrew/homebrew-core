class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7191c8b6259f8124d2bef4c38ab0bcb7f13923dd84a6ec5cb5512f729765f5b5"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a673e7ac718aa1815316acc9f07ea63e5e4bc904b5d1665ae808b067b014249"
    sha256 cellar: :any,                 arm64_sequoia: "ce9c8665c152cec1058062dda0b4504e580b43a7461dccb166162904342bd12d"
    sha256 cellar: :any,                 arm64_sonoma:  "97bc95437cd6242d6c238a6a0c45c3b6b1a5b5954038448cb5a830fcd1c89feb"
    sha256 cellar: :any,                 sonoma:        "38f7b48707ca8fe48f5178d83f8750a4a32bf04cf04902633f3a300212a829c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76177b535b02a93b97fb51d7a829adc5283f1f1d7cff702750f25355c87556e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d8fef40aa142c6a7eab74c7833c2d918ff083cd359269cac8502aa31d780ca"
  end

  depends_on "zig" => :build
  depends_on "mujs"
  depends_on "mupdf"

  # Patches for zig patch prior to that
  patch do
    url "https://github.com/freref/fancy-cat/commit/9839e77a0949f44ffa6615517e6b866a8f6e0222.patch?full_index=1"
    sha256 "0bd4725ee0e3415a1c33816bad5ec713806506c5cce6ccf474f400f0a623aee9"
  end
  patch do
    url "https://github.com/freref/fancy-cat/commit/50b106635f03163e12b7407ba3fe7e5a5563f545.patch?full_index=1"
    sha256 "e9250d6b033794c84d2af9827233f8f71939d97fbb4b3b834ea3c1328f222637"
  end
  patch do
    url "https://github.com/freref/fancy-cat/commit/033d32d5bb3f11cc194deaa80c7eb8cd4d583c04.patch?full_index=1"
    sha256 "5818a2845f396371bebc421c882ed190eca544035c818a86a5db15475ce361d9"
  end
  # Fix build with Zig 0.15.2
  patch do
    url "https://github.com/freref/fancy-cat/commit/f304c5907e52a62f4cf42953e9043d21ad9b47e9.patch?full_index=1"
    sha256 "9e4400ca09aac07f0641666b9da70f822c04c3c79811c7beddbd0aa0ac075ac2"
  end

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

    system "zig", "build", *args, *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
