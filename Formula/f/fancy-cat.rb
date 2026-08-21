class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8eb1251650d52dc406bbf0e353a5047ad874c155fc8272818184077e91568e2"
    sha256 cellar: :any, arm64_sequoia: "d5987c870d1bb7a1a2f2da565f80bebd5f789fd98edaae4ccc7ffe5a44bbdcea"
    sha256 cellar: :any, arm64_sonoma:  "dc50337be93ffe337e748634e7b8def7d3d1ecd5974fb48b3ac16e87c9966019"
    sha256 cellar: :any, sonoma:        "49804c28c10afdc953bb2147960a6c8c7058d235b2bfd96de1c1e5ce0a296198"
    sha256 cellar: :any, arm64_linux:   "95a96a5ce44b01e65432673d33851db934c23a4dabc7dfd38e6f584f6f596462"
    sha256 cellar: :any, x86_64_linux:  "6f693b1e6ad74531d2af0cf42c13034515adba05cd17c170916f4c332a7beaa4"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
