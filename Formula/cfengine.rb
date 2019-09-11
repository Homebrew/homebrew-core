class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.14.0.tar.gz"
  sha256 "738d9ade96817c26123046281b6dc8d3c325a2f0f3662e9b23a8e572a4cf4267"

  bottle do
    rebuild 1
    sha256 "4eaaf194545c426f58117c2518f7a5db49b8265cd4000abec839bd70f4a9062c" => :mojave
    sha256 "a221af5677518fd309917b61878dc8ba571a3f364e872c7e0c672449d5429ba1" => :high_sierra
    sha256 "9a1aa88f5a4b42ad4a5d2df2439cd3a49aa272c26746f4ae25a810291aecbdcc" => :sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.14.0.tar.gz"
    sha256 "1afea1fbeb8aae24541d62b0f8ed7633540b2a5eec99561fa1318dc171ff1c7c"
  end

  def install
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
