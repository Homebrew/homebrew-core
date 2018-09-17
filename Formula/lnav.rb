class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.4/lnav-0.8.4.tar.gz"
  sha256 "22283a59eca51f85dd3283eea1f326fdaa175d9a7a4957a6edf8fb894a1f891d"

  bottle do
    sha256 "2fd7a4d77dc91c33314e87a3b6f34d70f6aad47deac63fe14ca33f0181ebcb05" => :mojave
    sha256 "e7a3dd56d462d6bc1373dc15245a9a5baead456b6368449688c2a9b8b87e98c2" => :high_sierra
    sha256 "2ce8bb7aa0c2102abeb4e4c0e5d61c1aa55156e7de67587698cfe29f78043730" => :sierra
    sha256 "20a996133ad0b0f753e2b0ca619471dee7683ed479a652cf84b1f3758386b033" => :el_capitan
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
  depends_on "sqlite" if MacOS.version < :sierra

  def install
    # Fix errors such as "use of undeclared identifier 'sqlite3_value_subtype'"
    ENV.delete("SDKROOT")

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
