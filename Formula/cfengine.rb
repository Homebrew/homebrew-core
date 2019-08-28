class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.14.0.tar.gz"
  sha256 "738d9ade96817c26123046281b6dc8d3c325a2f0f3662e9b23a8e572a4cf4267"

  bottle do
    sha256 "b3fb31ea7b58615a30f7ebb57c97d41ce61968d4e953d98698f680e9de443115" => :mojave
    sha256 "e1892ccbf8be6c15bb7c8669e504613078fbef9d2e03140186f60ec9298b9cc0" => :high_sierra
    sha256 "dcbd099ab9bb0684485dddb46b2aec6351662f6b3a4b559e37005c477e1b0909" => :sierra
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
