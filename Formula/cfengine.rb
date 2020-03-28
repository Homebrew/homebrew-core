class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.1.tar.gz"
  sha256 "ab597456f9d44d907bb5a2e82b8ce2af01e9c59641dc828457cd768ef05a831d"

  bottle do
    sha256 "ef667d58ff32efffd138990854dfaaa9a85fb8eb2542a19b9179041def1fa774" => :catalina
    sha256 "f83a9a2297adaad480425fd77f48c5c1ecabfa5d140c1217353d9f4c8e6e399d" => :mojave
    sha256 "54b6be6b949cee268524b61ca0e72b687a6823058e9e9a8849c90ee98d75ecf9" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.1.tar.gz"
    sha256 "051369054a2e17a4ea1f68a41198fe5377fbbf33f600168246bf0b667fc1ab74"
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
