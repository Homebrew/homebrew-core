class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.80.tar.bz2"
  sha256 "fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa"
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "9a9bfb7842cb631f4d48384e7f0624540c109c1fbf16dc1df3a2bab521392f61" => :mojave
    sha256 "ef7ef98c6b83c013727eea37c37dcfa04eb6a572dc03699920cd7fc76a7f358a" => :high_sierra
    sha256 "a39669b4c391823e7f42407654475539d7b4b58bc343817c6bfb96bc4063e848" => :sierra
    sha256 "a597fa10396be4a782a198f4af51565c15dc8ae59cbe8c367bb78fd3babd972e" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
