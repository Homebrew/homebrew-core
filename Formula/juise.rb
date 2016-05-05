class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.7.2/juise-0.7.2.tar.gz"
  sha256 "869f18cb6095c2340872bc02235530616fcfc2e88c523c6a05238a521d0afe82"

  bottle do
    sha256 "da6dcf67dee23e98befee63f93796490a877229679e77befa25246da59756822" => :mavericks
    sha256 "abcd4d9e493d030922978364f95b7e91c38f99e661c9fa118a666c282abe3758" => :mountain_lion
    sha256 "076b551d5489dd55636e7c5945b593ad75219416c95bd61656cc7cfd45ea2e8f" => :lion
  end

  head do
    url "https://github.com/Juniper/juise.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "libslax"

  def install
    system "sh", "./bin/setup.sh" if build.head?

    # Prevent sandbox violation where juise's `make install` tries to
    # write to "/usr/local/Cellar/libslax/0.20.1/lib/slax/extensions"
    # Reported 5th May 2016: https://github.com/Juniper/juise/issues/34
    inreplace "configure",
      "SLAX_EXTDIR=\"`$SLAX_CONFIG --extdir | head -1`\"",
      "SLAX_EXTDIR=\"#{lib}/slax/extensions\""

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    assert_equal "libjuice version #{version}", shell_output("#{bin}/juise -V").lines.first.chomp
  end
end
