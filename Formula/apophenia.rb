class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info"
  url "https://github.com/b-k/apophenia/archive/refs/tags/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f41ec39ddf34211bf5689b608a4f6cd86b14f0933e1931a57aaf6ebfde511311"
    sha256 cellar: :any,                 arm64_monterey: "bfa9a7f6b132f1b892a36476b75f16422b97d3dc60b312e46c4ae53f8be733f7"
    sha256 cellar: :any,                 arm64_big_sur:  "dcae1c229f1768e8cac6f01cc1cf26c46d3773613e3d151ba2c597c196683832"
    sha256 cellar: :any,                 ventura:        "35b4555478efe07e652b58ccdd5091f166de91f1d63d52569666e6118a46bb40"
    sha256 cellar: :any,                 monterey:       "f1c89d71177bf8a59c85f5d74579d58d3186bf1aa352bf645c02ff4fce24da42"
    sha256 cellar: :any,                 big_sur:        "3d9e51918d69791a400e6d422bef5523d0f2fa023b584eb7ccf66a5c76def9c9"
    sha256 cellar: :any,                 catalina:       "4b133cfb7f2160a8b361c5359dad886468fd5042af9fa8a243e93bfe7227f9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25526fc2962d8c205f7a62109a83564b5535d6fb68068a0905bd798f32f7f052"
  end

  depends_on "gsl"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Regenerate configure to avoid binaries being built with flat namespace
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"foo.csv").write <<~EOS
      thud,bump
      1,2
      3,4
      5,6
      7,8
    EOS

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
