class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7191c8b6259f8124d2bef4c38ab0bcb7f13923dd84a6ec5cb5512f729765f5b5"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be3682c2a12a9d5301eabb6b3411030df73a0b4a7411ffd8ce1c4d184bd3c03a"
    sha256 cellar: :any,                 arm64_sequoia: "91c9480e951f51c83f4c721f31fbff89d54ce65c7c4a9edd017a5831c7c2fe78"
    sha256 cellar: :any,                 arm64_sonoma:  "1595f3eac4982da89dda214d4530ad359b2ffb88bc2c3f4429d91d6ad90311f0"
    sha256 cellar: :any,                 sonoma:        "2361cd185ca9cfdd8951d001c9cd1ec7e1f480e8540132bf5a1ff63269cd3afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b87def3bba34f0788cc95d4d94d810cd4d0d43bca81f914cf777f8a84b64036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5ffe30dddcc490977660ae346b29d46cc2b440fe9e23b899b99ed9ba4df542"
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
