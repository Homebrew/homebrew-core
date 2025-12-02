class Aamath < Formula
  desc "Renders mathematical expressions as ASCII art"
  homepage "http://fuse.superglue.se/aamath/"
  url "http://fuse.superglue.se/aamath/aamath-0.3.tar.gz"
  sha256 "9843f4588695e2cd55ce5d8f58921d4f255e0e65ed9569e1dcddf3f68f77b631"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?aamath[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587054f7e1107e61554956c8ba147c9560af1e7138547651ba82d32464c0862c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb04795cf214c974e4e45cb8c369dad3232624dd070641a4f408808fbd98d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bc9d4ebf6c7eb4e4634f79fdd297aa57c87d570f0e3f6937c9bf104d0c0f2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "56c65eaae7db0c86ca690b79cde6894c281877f00c18965975b4e4fd91b4fe71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912312e5d565a7255691d9cff437f1e66419054dc75365cda3af747ef5bf5c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79b5ff4704b7f8393182ee3b68f5343a745e5e62ad4b2db90b3b4f28c186ae52"
  end

  uses_from_macos "bison" => :build # for yacc
  uses_from_macos "flex" => :build
  uses_from_macos "libedit" # readline's license is incompatible with GPL-2.0-only

  # Fix build on clang; patch by Homebrew team
  # https://github.com/Homebrew/homebrew/issues/23872
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/aamath/0.3.patch"
    sha256 "9443881d7950ac8d2da217a23ae3f2c936fbd6880f34dceba717f1246d8608f1"
  end

  def install
    unless OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} -I#{Formula["libedit"].opt_libexec}/include"
        s.change_make_var! "LFLAGS", "#{s.get_make_var("LFLAGS")} -L#{Formula["libedit"].opt_libexec}/lib"
      end
    end

    ENV.deparallelize
    system "make"

    bin.install "aamath"
    man1.install "aamath.1"
    prefix.install "testcases"
  end

  test do
    s = pipe_output(bin/"aamath", (prefix/"testcases").read, 0)
    assert_match "f(x + h) = f(x) + h f'(x)", s
  end
end
