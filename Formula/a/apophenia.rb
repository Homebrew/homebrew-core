class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "https://github.com/b-k/apophenia"
  url "https://github.com/b-k/apophenia/archive/refs/tags/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"
  license "GPL-2.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "44c30149c9a30ba1c3eabfde55df2aa654127cd2788bddef59c67dc61b79531d"
    sha256 cellar: :any,                 arm64_sequoia:  "45407a002d3d36f5c0e0e1b286a7097074d389691e119c42b17681e086b48473"
    sha256 cellar: :any,                 arm64_sonoma:   "46a4119ca0d9f934fad32688b6a85ae8206a5f86f8e64b9d3680201398c1bee2"
    sha256 cellar: :any,                 arm64_ventura:  "4cfac020f8c94bf825b0b21b2c56eb77d815d8eff4b935eecc7f69825ac7f69d"
    sha256 cellar: :any,                 arm64_monterey: "dad0483f7c96479a293715d97dab14df9cc1fbec0378f2bf97fc17b64aa2c2e5"
    sha256 cellar: :any,                 sonoma:         "cde422f8be856275c3fb3d2092929101bafcbbee62cb9486d1b59378b02b004a"
    sha256 cellar: :any,                 ventura:        "104c954cb700c12c225829809d209c7c5861c57ef05a0ada3f9cb0e6e8a61935"
    sha256 cellar: :any,                 monterey:       "a449794eaa411f25d9df192964a641bb773cbe80b0f873cd158a1dbd1e1d45c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d28856a30a244da835dc65df83285e22c654e7e449e56d0cf2a7748bc9ede283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2980951404674b5fc9a6957d6fe7ebb8ae0ded37f3c0c444c732115f5b3f6638"
  end

  depends_on "gsl"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix compilation with POSIX basename(3)
  # Patches already accepted upstream, remove on next release
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/apophenia/posix-basename.diff"
    sha256 "9d8d92c850cdb671032679e3ef46dafda96ffa6daf39769573392605cea41af3"
  end

  def install
    # Regenerate configure to avoid binaries being built with flat namespace
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"foo.csv").write <<~CSV
      thud,bump
      1,2
      3,4
      5,6
      7,8
    CSV

    expected_gnuplot_output = <<~EOS
      plot '-' with lines
          1\t    2
          3\t    4
          5\t    6
          7\t    8
    EOS

    system bin/"apop_text_to_db", testpath/"foo.csv", "bar", testpath/"baz.db"
    sqlite_output = shell_output("sqlite3 baz.db '.mode csv' '.headers on' 'select * from bar'")
    assert_equal (testpath/"foo.csv").read, sqlite_output.gsub(/\r\n?/, "\n")

    query_output = shell_output("#{bin}/apop_plot_query -d #{testpath/"baz.db"} -q 'select thud,bump from bar' -f-")
    assert_equal query_output, expected_gnuplot_output
  end
end
