class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.8/ffe-0.3.8.tar.gz"
  sha256 "46f4e728e3f9bb73a021afc1080972356bbd6d6c883598d8fd7876ad44b60835"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccecbf9c6595344a6988ed708a38bb18d8d754d5e948e9e9a0d8fd2b933e1eec" => :high_sierra
    sha256 "9471c2e19149beb552d0f7b724b6f6f140b2f2dd26d180f8293d6e95a704907f" => :sierra
    sha256 "a85474d61e83b870dd30b1df63b16eb28cc87f18c74d4484e49f5719b2ebad43" => :el_capitan
    sha256 "df84e69d719b76fd4c9dd6d7462c2dabcad331454dd20f64ba55ab0a0a7ba03d" => :yosemite
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
