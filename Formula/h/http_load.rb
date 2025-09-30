class HttpLoad < Formula
  desc "Test throughput of a web server by running parallel fetches"
  homepage "https://www.acme.com/software/http_load/"
  url "https://www.acme.com/software/http_load/http_load-09Mar2016.tar.gz"
  version "20160309"
  sha256 "5a7b00688680e3fca8726dc836fd3f94f403fde831c71d73d9a1537f215b4587"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?http_load[._-]v?(\d+[a-z]+\d+)\.t/i)
    strategy :page_match do |page, regex|
      # Convert date-based version from 09Mar2016 format to 20160309
      page.scan(regex).map do |match|
        date_str = match&.first
        date_str ? Date.parse(date_str)&.strftime("%Y%m%d") : nil
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "5b5b959ce2f9aae731f7234d123194dfc5694d31b1dcd505b98546a0bbec14f7"
    sha256 cellar: :any,                 arm64_sequoia:  "3d19f59b28f7f602e80aef16d2455d98513a6886a58910287ac5845bdcd9733b"
    sha256 cellar: :any,                 arm64_sonoma:   "185664add7e628ad4614228aef6bf0b18356077ddd71abf3eae39ae12a2e2d03"
    sha256 cellar: :any,                 arm64_ventura:  "4349eea05cac8aef36a6243f8051208cddfda24966252b1ca079c3a89855b913"
    sha256 cellar: :any,                 arm64_monterey: "b4a5b7e79f524a59d414c14ff40ea8ad5a0871a6c98606e721c8f83320cdd230"
    sha256 cellar: :any,                 arm64_big_sur:  "f8ad486c4e8c9eb7f5204584c74de6e366e3e2ab1452682dc9904badec75e4d5"
    sha256 cellar: :any,                 sonoma:         "27129e350fa06c4e302145c55a83a0b41f4ab96ebf371de001151d537929ccb8"
    sha256 cellar: :any,                 ventura:        "a6416934e52f12730249f9175afefb89dda92f939aa880961b48613561eeb124"
    sha256 cellar: :any,                 monterey:       "03949d76fa9a565a4e52e3219a097eef0453bb082a77674a16a66e407f6bba24"
    sha256 cellar: :any,                 big_sur:        "04650d6cbf5dce7109ed1ce45a1bad45ae6d2706d3b5dd2baf411b198a3c5e27"
    sha256 cellar: :any,                 catalina:       "6989c80f8d5213ed9e9586707e8ce2ab503b5d7bf6d10fadddd8bc310575f452"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21d002bd2aa7f0c6f9bb57c13777d961e01a3e149769017c6ed91cb4a1ea0f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5172c491fea4e76a68983d8fe6563a97e2ed2bef73b6bb0c95f5290282343116"
  end

  depends_on "openssl@3"

  def install
    bin.mkpath
    man1.mkpath

    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
      SSL_TREE=#{Formula["openssl@3"].opt_prefix}
    ]

    inreplace "Makefile", "#SSL_", "SSL_"
    system "make", "install", *args
  end

  test do
    (testpath/"urls").write "https://brew.sh/"
    system bin/"http_load", "-rate", "1", "-fetches", "1", "urls"
  end
end
