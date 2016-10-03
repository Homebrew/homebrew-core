class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.9.0.tar.gz"
  sha256 "32a38aedf1199c2361e1335e0d4a1d98f9efa7cd591bcb647f35c7395bb66f2d"

  bottle do
    cellar :any
    sha256 "2b4b6e89499fc8f54c30252b8d74572611ee7e8ac39f449129da96fca6f414e6" => :el_capitan
    sha256 "cb6c2974f852eefab238ac9d9da37db105e0dd8b07c02529edbdfab7a3457f39" => :yosemite
    sha256 "f9259787ea468667fa14062b343b15dc31b71268b0aca2d0612e38c2ba66459d" => :mavericks
  end

  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "pcre"
  depends_on "lmdb"
  depends_on "openssl"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.9.0.tar.gz"
    sha256 "63dec2f8649f5f2788cd463dccf47f8dbe941522acfcf3093517f983bbfa0606"
  end

  def install
    # Fix "typedef redefinition with different types"
    if DevelopmentTools.clang_build_version >= 800
      ENV["ac_cv_type_clockid_t"] = "yes"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
