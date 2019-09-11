class Irods < Formula
  desc "Integrated data grid software solution"
  homepage "https://irods.org/"
  url "https://github.com/irods/irods-legacy/archive/3.3.1.tar.gz"
  sha256 "e34e7be8646317d5be1c84e680d8f59d50a223ea25a3c9717b6bf7b57df5b9f6"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e813a4cf5f735101c687a61781acc3e0340c0955ae9fa4d91ba14b49de1831cd" => :mojave
    sha256 "cac5382129bb016d59c27f47a6e947ad76448727671b6852d6667154bcf673b0" => :high_sierra
    sha256 "780af7affdcd352f2efdd03e3e801ad48d2daf757986b1ac876bdcfcbc9801af" => :sierra
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  conflicts_with "sleuthkit", :because => "both install `ils`"
  conflicts_with "renameutils",
    :because => "both install `icp` and `imv` binaries"

  def install
    cd "iRODS" do
      system "./scripts/configure"

      # include PAM authentication by default
      inreplace "config/config.mk", "# PAM_AUTH = 1", "PAM_AUTH = 1"
      inreplace "config/config.mk", "# USE_SSL = 1", "USE_SSL = 1"

      system "make"
      bin.install Dir["clients/icommands/bin/*"].select { |f| File.executable? f }
    end
  end

  test do
    system "#{bin}/ipwd"
  end
end
