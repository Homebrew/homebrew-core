class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.9/ffe-0.3.9.tar.gz"
  sha256 "78bab8fa1068a62600c3de153122b8fc9252080ddbc521f71b938b5dbd9afb0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "59d1950fc3b1ed9baccaa08b100a4768e1a5dd21895623d1bbb99077218426fb" => :catalina
    sha256 "845ba501eb75d9f3d0466e95700c5b04511a3908dd2fa8b0a3dd06e611a937c4" => :mojave
    sha256 "3415f4fa4e7407929bfc62ac70c663a48669d39a38375524319851cf396abacb" => :high_sierra
    sha256 "e454fbfb4ac9947f7e7222e7af911cc89a502bee98ab41301f2fe5ecf1f4b8a9" => :sierra
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
