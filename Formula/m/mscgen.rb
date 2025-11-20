class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "https://www.mcternan.me.uk/mscgen/"
  url "https://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?mscgen-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d9abf0e71de052136e3396ebb6bdfed805d918edb13f252eb052ab35e1704b89"
    sha256 cellar: :any,                 arm64_sequoia:  "ba7b5077209a47d9ab11f8d19d7d47ee0162f1fa30c20fd1e464c699e64eb9bd"
    sha256 cellar: :any,                 arm64_sonoma:   "685f813d386e9429db8d73bbdf201176f7842ccbe533d18d33b0d248b8484d7b"
    sha256 cellar: :any,                 arm64_ventura:  "73676ae3da025d8b7aaabc9809c3f65c3b6ae85a8d69850d7bd30bd5af0007ce"
    sha256 cellar: :any,                 arm64_monterey: "3cd61f8ca37330ef4a7ba26132a5d3bdb3eea68f4f41307064dadc3dc5649fa5"
    sha256 cellar: :any,                 arm64_big_sur:  "cede56d6cd047fde4bb154591914ee1123d118080114fb82a5b156b895f8fad4"
    sha256 cellar: :any,                 sonoma:         "f7d48ef03be95a70f00a7c5432e2a232b0b0236e00db68b9b9727bddfbd153f4"
    sha256 cellar: :any,                 ventura:        "b500d3fa67b119c59ff1a781dfe0909b12d0e3c9581ec1cf9cfcf39940a4c4f9"
    sha256 cellar: :any,                 monterey:       "d031bdc4d5456838a3b0c8d60108309e3b2878067fda80b747cd2c6de90cccb1"
    sha256 cellar: :any,                 big_sur:        "a62050a8f5e00af5a06fde06f2d87acc030dba511a1b6b97f49ea148423c6776"
    sha256 cellar: :any,                 catalina:       "aaa059273a50cf91bca121c093ce2adfd8bee71d854c6212df2d63b4bf7811e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b39667ceae160bffbf727a7ffcb6624325234c9ed3b3691e324c99f29f6e9f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5957b2f4840517592807494271eb28d63b5c245ac014d34be596fb0355129031"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "gd"

  def install
    system "./configure", "--with-freetype", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.msc").write <<~EOS
      msc {
        width = "800";
        a, b, "c";
        a->b;
        a<-c [label="return"];
      }
    EOS

    expected_svg = <<~EOS
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
       "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
      <svg version="1.1"
       width="798px" height="78px"
       viewBox="0 0 798 78"
       xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges"
       stroke-width="1" text-rendering="geometricPrecision">
      <polygon fill="white" points="128,7 136,7 136,16 128,16"/>
      <text x="133" y="16" textLength="7" font-family="Helvetica" font-size="12" fill="black" text-anchor="middle">

      a
      </text>
      <polygon fill="white" points="394,7 402,7 402,16 394,16"/>
      <text x="399" y="16" textLength="7" font-family="Helvetica" font-size="12" fill="black" text-anchor="middle">

      b
      </text>
      <polygon fill="white" points="660,7 668,7 668,16 660,16"/>
      <text x="665" y="16" textLength="6" font-family="Helvetica" font-size="12" fill="black" text-anchor="middle">

      c
      </text>
      <line x1="133" y1="22" x2="133" y2="50" stroke="black"/>
      <line x1="399" y1="22" x2="399" y2="50" stroke="black"/>
      <line x1="665" y1="22" x2="665" y2="50" stroke="black"/>
      <line x1="133" y1="33" x2="399" y2="33" stroke="black"/>
      <line x1="399" y1="33" x2="389" y2="39" stroke="black"/>
      <line x1="133" y1="50" x2="133" y2="78" stroke="black"/>
      <line x1="399" y1="50" x2="399" y2="78" stroke="black"/>
      <line x1="665" y1="50" x2="665" y2="78" stroke="black"/>
      <line x1="665" y1="61" x2="133" y2="61" stroke="black"/>
      <line x1="133" y1="61" x2="143" y2="67" stroke="black"/>
      <polygon fill="white" points="382,51 415,51 415,60 382,60"/>
      <text x="383" y="60" textLength="31" font-family="Helvetica" font-size="12" fill="black">
      return
      </text>
      <line x1="133" y1="72" x2="133" y2="78" stroke="black"/>
      <line x1="399" y1="72" x2="399" y2="78" stroke="black"/>
      <line x1="665" y1="72" x2="665" y2="78" stroke="black"/>
      </svg>
    EOS

    system bin/"mscgen", "-Tsvg", "-o", testpath/"test.svg", testpath/"test.msc"
    assert_equal expected_svg, (testpath/"test.svg").read
  end
end
