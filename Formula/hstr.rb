class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.5.tar.gz"
  sha256 "7f5933fc07d55d09d5f7f9a6fbfdfc556d8a7d8575c3890ac1e672adabd2bec4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d96af0e7736760fc87ed5e2ac7060305b62691c4e29e5767d95b01efffc764fb"
    sha256 cellar: :any,                 arm64_big_sur:  "e03468773a860e4f629ddd11fbc02354209ee4eac78992e66c922accc13124d6"
    sha256 cellar: :any,                 monterey:       "cc58407f21f17b5d2f76ca4c47dbc316109c290c939f96a61197ba2e468fa5bb"
    sha256 cellar: :any,                 big_sur:        "53d82b6cef30db4afbe9d8cf00a28a29f6c1a7766c6acb2cd965c72a6dee0ff7"
    sha256 cellar: :any,                 catalina:       "7c3ac14533a2329de8563a8d59887c8459659496fbbe47570183ced1b2b7e96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45c4fdce56c1ac4f334e136664112008e86ee845f0bdb63a153c4b9edabed62"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_equal "test", shell_output("#{bin}/hh -n").chomp
  end
end
