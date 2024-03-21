class Gap < Formula
  desc "Groups, Algorithms, Programming - A system for computational discrete algebra"
  homepage "https://www.gap-system.org"
  url "https://github.com/gap-system/gap/releases/download/v4.13.0/gap-4.13.0.tar.gz"
  sha256 "cc76ecbe33d6719450a593e613fb87e9e4247faa876f632dd0f97c398f92265d"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "libtool" => :build
  depends_on "readline" => :build
  depends_on :xcode
  uses_from_macos "zlib" => :build

  def install
    system "./configure",
      "--prefix=#{prefix}",
      "--with-gmp=#{Formula["gmp"].include}",
      "--with-readline=#{Formula["readline"].include}"
    system "make", "install"
    pkgshare.install "pkg"
  end

  test do
    system bin/"gap", "--version"

    (testpath/"m11.gap").write <<-EOS
      m11 := Group((1,2,3,4,5,6,7,8,9,10,11),(3,7,11,8)(4,10,5,6));
      s := Size( m11 );
      PrintTo("m11.txt", s);
      QUIT;
    EOS
    system bin/"gap", "m11.gap"

    assert_equal "7920", `cat m11.txt`.strip
  end
end
