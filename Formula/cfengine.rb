class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.0.tar.gz"
  sha256 "fa53e137f850eb268a8e7ae4578b5db5dc383656341f5053dc1a353ed0288265"

  bottle do
    sha256 "ef667d58ff32efffd138990854dfaaa9a85fb8eb2542a19b9179041def1fa774" => :catalina
    sha256 "f83a9a2297adaad480425fd77f48c5c1ecabfa5d140c1217353d9f4c8e6e399d" => :mojave
    sha256 "54b6be6b949cee268524b61ca0e72b687a6823058e9e9a8849c90ee98d75ecf9" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.0.tar.gz"
    sha256 "4a071c0c4ba7df9bad93144cff5fbc0566e5172afd66201072e3193b76c55a38"
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
