class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.7/ffe-0.3.7.tar.gz"
  sha256 "20ef5fda32e6576e7c81a7a30f2929e99eb84ddeb0f2fa7fa8337e8c6c740141"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8c56b7ac4c2fdd8c67716aacca8857ce364d8711b6ff09340d5b9feedba3481" => :sierra
    sha256 "666dc2469aeaf63a90ce687eba70efa56c955acd768664c96a1bf85fe8dcb9d6" => :el_capitan
    sha256 "526a95e0b9565c15a2fb6dfd2ad7ce3bb58d56872c1a8bb203c4ea2093b09929" => :yosemite
  end

  def install
    # Work around build failure "ffe.c:326:23: error: non-void function
    # 'update_anon_info' should return a value [-Wreturn-type]"
    # Reported 7 Feb 2017 to tjsa@iki.fi
    ENV.append_to_cflags "-Wno-return-type"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"source").write "EArthur Guinness   25"
    (testpath/"test.rc").write <<-EOS.undent
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
