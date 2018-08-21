class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.8/ffe-0.3.8.tar.gz"
  sha256 "46f4e728e3f9bb73a021afc1080972356bbd6d6c883598d8fd7876ad44b60835"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d9c309dcdcda9aeecf1818242e759ec97482abb6e3e093991cd7671fc80f5c1" => :mojave
    sha256 "42240b29cbf5a1f54881c37d1062d8466f763dcefdef56690830012a585c1c5c" => :high_sierra
    sha256 "a023c41a3bbef25ab1eb38b2e7ff202f93b580242df0b883b39e30e82e966d92" => :sierra
    sha256 "192298bb0e1b0594b64831a943cf4d0e490d17d633b2ea4d3b225fa119705e6a" => :el_capitan
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
