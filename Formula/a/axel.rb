class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.11/axel-2.17.11.tar.xz"
  sha256 "580b2c18692482fd7f1e2b2819159484311ffc50f6d18924dceb80fd41d4ccf9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "3f196f17b1043e0a5531749fa1e21a87d350fa70e3cf846efb6d7115c979be33"
    sha256 cellar: :any, arm64_monterey: "fc825bed920a30d02258383bdf1f14badc453adbf9cce3c8e628e221efbf7db5"
    sha256 cellar: :any, arm64_big_sur:  "a1815f9d311241ce68c81b0f21daad17ab08f3c0fad600b9116f457a3ae5262f"
    sha256 cellar: :any, ventura:        "bb1aa80792b4fa114433ca1f3f92163ed16e8e467e352c32c502193d7a70e2a7"
    sha256 cellar: :any, monterey:       "348ee3ec9805d19c50eb3fe8ffae5ddef7c3f123bdd75612dcd9c05c5311ec0a"
    sha256 cellar: :any, big_sur:        "42d32e7d0d52b145d2965bb88b158f82c232688413d4bd34498e3f25b25b8da7"
    sha256 cellar: :any, catalina:       "4e9cdfa03a735c0e169f482ab16af3296cbcbd7585eb7134b2de93aa335b7328"
    sha256               x86_64_linux:   "9cb9766adfe1f050725b01426fd2b499f7a970e7a15406b7fc02e5e4b7b030d2"
  end

  head do
    url "https://github.com/axel-download-accelerator/axel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gawk" => :build

    resource "txt2man" do
      url "https://github.com/mvertes/txt2man/archive/refs/tags/txt2man-1.7.1.tar.gz"
      sha256 "4d9b1bfa2b7a5265b4e5cb3aebc1078323b029aa961b6836d8f96aba6a9e434d"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  def install
    if build.head?
      resource("txt2man").stage { (buildpath/"txt2man").install "txt2man" }
      ENV.prepend_path "PATH", buildpath/"txt2man"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
