class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "http://www.linux-pam.org"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.5.2/Linux-PAM-1.5.2.tar.xz"
  sha256 "e4ec7131a91da44512574268f493c6d8ca105c87091691b8e9b56ca685d4f94d"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  head "https://github.com/linux-pam/linux-pam.git"

  bottle do
    sha256 x86_64_linux: "5beee64dc646a1b870bee7b07259cbf2eb66146d2856233f5a17c69db709be4d"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libprelude"
  depends_on "libtirpc"
  depends_on :linux

  skip_clean :la

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-selinux
      --prefix=#{prefix}
      --includedir=#{include}/security
      --oldincludedir=#{include}
      --enable-securedir=#{lib}/security
      --sysconfdir=#{etc}
      --with-xml-catalog=#{etc}/xml/catalog
      --with-libprelude-prefix=#{Formula["libprelude"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage: #{sbin}/mkhomedir_helper <username>",
                 shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
