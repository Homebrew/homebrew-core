class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ff-extractor/0.3.9a/0.3.9a.tar.gz"
  version "0.3.9a"
  sha256 "3f3433c6e8714f9756826279e249bcf7f7ab8c45b5686003764e44f63eb225e7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:ffe[._-])?v?(\d+(?:\.\d+)+(?:-\d+)?[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6439a12e9180af68d7dbdcfe34542acac6ae00b68b1dd76af01caca53b6fea70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d3e8b3f5351665de15fb7ea4904b873cd7c3c04cefde6f6b0534a16dc7dbef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fc8ca59fce53552b827be4e9bfdc9c263c8087961245704277be10915fb6d20"
    sha256 cellar: :any_skip_relocation, ventura:        "33ad5a55c582f1010abc77265a3ded3217a771b87a749809868184d74a115c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "296af9a5f1d536172be945d4856dc659441b6c8129ab0b6bc865f97d0ffc9b6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ed6ad86d89e339ff49c9ed615ca5e44dd1aa67b534b0644ae09accb31f4d80"
    sha256 cellar: :any_skip_relocation, catalina:       "f702acaeb2f1c1c8681b67e7725827b5a33b46a9f11c6138682b715c0a652798"
    sha256 cellar: :any_skip_relocation, mojave:         "50a6933b42632612de08af50fead023d23c04593ecb323749f950b05df9f034e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583204b3a7ac459ad0ab5d76d7cea314103dc499d271ddfd2309f053e795c41f"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"source").write "EArthur Guinness   25"
    (testpath/"test.rc").write <<~EOS
      structure personel_fix {
        type fixed
        record employee {
          id 1 E
          field EmpType 1
          field FirstName 7
          field LastName  11
          field Age 2
        }
      }
      output default {
        record_header "<tr>"
        data "<td>%t</td>"
        record_trailer "</tr>"
        no-data-print no
      }
    EOS

    system "#{bin}/ffe", "-c", "test.rc", "source"
  end
end
