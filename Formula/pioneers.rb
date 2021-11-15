class Pioneers < Formula
  desc "Settlers of Catan clone"
  homepage "https://pio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pio/Source/pioneers-15.6.tar.gz"
  sha256 "9a358d88548e3866e14c46c2707f66c98f8040a7857d47965e1ed9805aeb631d"

  bottle do
    sha256 arm64_big_sur: "ef6e9c03dcc0c5d86ae0b08805352937c74d4ccaadbe4ac9aead56b5f7e0c7bb"
    sha256 monterey:      "0e14d946b05d63aba6c15ad997bb4bc2998fe33c7293c14aec0763e8cfa89a99"
    sha256 big_sur:       "b9297939922709fc05a78ee98b24091678bf4e434bea4abfc14b089fde6e9728"
    sha256 catalina:      "c2462078e412d1e2b60108f317550690b28675da5a248de69856a558fa4e07d4"
    sha256 mojave:        "47ca43b992b0590f90758d9eef7894361c510dce5279a602decdf8ec019086f4"
    sha256 high_sierra:   "fdd30d2f45b5b1f701b2f358c09a79ce04cea9793383f959811141617f3a4fc0"
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "librsvg" # svg images for gdk-pixbuf

  def install
    # fix usage of echo options not supported by sh
    inreplace "Makefile.in", /\becho/, "/bin/echo"

    # GNU ld-only options
    inreplace Dir["configure{,.ac}"] do |s|
      s.gsub!(/ -Wl,--as-needed/, "")
      s.gsub!(/ -Wl,-z,(relro|now)/, "")
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pioneers-editor", "--help"
    server = fork do
      system "#{bin}/pioneers-server-console"
    end
    sleep 5
    Process.kill("TERM", server)
  end
end
