class Moira < Formula
  desc "Clients for the Athena Service Management System"
  homepage "https://debathena.mit.edu"
  url "https://github.com/mit-athena/moira/archive/4.0.0.3+51+g65d55c5.tar.gz"
  sha256 "d418681ae4ec61a124c55fb67a6bba0d89b59dc760c4d1c9a1e8e1c9c7b69b19"

  option "with-krb5", "Build with homebrew/dupes/krb5"

  depends_on "e2fsprogs" # for com_err, as recommended by Debian packaging
  depends_on "hesiod"
  depends_on "homebrew/dupes/krb5" if build.with? "krb5"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-com_err=#{Formula["e2fsprogs"].opt_prefix}
      --without-krb4
      --with-hesiod=#{Formula["hesiod"].opt_prefix}
      --without-zephyr
      --without-oracle
      --without-afs
      --disable-rpath
      --mandir=#{man}
    ]

    if build.with? "krb5"
      args << "--with-krb5=#{Formula["krb5"].opt_prefix}"
    else
      args << "--with-krb5"
    end

    cd "moira" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
    cd bin do
      mv "chfn", "chfn.moira"
      mv "chsh", "chsh.moira"
    end
    cd man1 do
      mv "chsh.1", "chsh.moira.1"
      mv "chfn.1", "chfn.moira.1"
    end
  end

  test do
    system "#{bin}/blanche", "ops", "-i", "-noauth"
    system "#{bin}/eunice", "enis", "-noauth"
    system "#{bin}/mitch", "Machines/IST", "-noauth"
    system "#{bin}/qy", "giql", "-s"
    system "#{bin}/stella", "ist", "-noauth"
  end
end
