class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.41.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.41.tar.xz"
  sha256 "fc9261cdc361d95e33da08762cafe57f8b73ab2598f9073986f0f9e8ad64a813"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1b7bfcbc6d961b138dbe30db866440bd6f56b5f6b7b503adc506665621b6a599" => :el_capitan
    sha256 "442a646275cac874c93ca7edd9147ad084e286359ed90762296afb65492cb18e" => :yosemite
    sha256 "a82a06c8e00a7188315891f06529f460fc995db9cdb65bf59c4b1a24e3366329" => :mavericks
  end

  depends_on "gnupg" => :optional
  depends_on "abook" => :recommended

  deprecated_option "with-gpg" => "with-gnupg"

  def install
    args = %W[
      --prefix=#{prefix}
      --libdir=#{libexec}
    ]
    args << "--with-gpg" if build.with? "gnupg"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
