class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "https://software.in2p3.fr/bbftp/"
  url "https://software.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "3adb6837d00aae2dd6425d06aa6ccf9450e8d6eaac66d4be597a7d97866d30a2" => :catalina
    sha256 "bbb282078bb4f4390bf219a319a1d20020a76e14fb853afc473e7f59f3f71a01" => :mojave
    sha256 "33ccc8c932f462488401f3963c1c5aff2ab489e16c1df067c619c5b6a791ced7" => :high_sierra
    sha256 "535b7b8db22c9ef92ba7ecf8fea093c3d0c9bc5c01d99277fb2ff04d9272b843" => :sierra
  end

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if MacOS.version >= :yosemite

    cd "bbftpc" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--without-ssl",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
