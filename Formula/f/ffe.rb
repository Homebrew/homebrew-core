class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://github.com/igitur/ffe"
  url "https://github.com/igitur/ffe/archive/refs/tags/v0.4.1d.tar.gz"
  version "0.4.1d"
  sha256 "2a5914de7779b9021031810ccafbcb8c15d47b17662559e976b304478c3d949c"
  license "GPL-2.0-or-later"
  head "https://github.com/igitur/ffe.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "886ec4521d356473de7d394b239edc09b36516e623538c2ce73edfd91e87f02d"
    sha256 cellar: :any, arm64_tahoe:       "80a23795b378c141a9850dbd8908a02d30321da235c6419758ffbd497f21fd46"
    sha256 cellar: :any, arm64_sequoia:     "e829feae034fdba3f88975d915cdafc8e2a54b847daf586ee5001bda05cbb16f"
    sha256 cellar: :any, arm64_linux:       "2928e6b1ae568b415c7cd82f426b09ff44a3bf86789bd83e92ef86696f94a893"
    sha256 cellar: :any, x86_64_linux:      "c30b449da5e23a74842bf10f9d48dd38e849d82b10ba7dc46a60182f384e4413"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  deny_network_access!

  def install
    ENV.append "CFLAGS", "-std=gnu89" if DevelopmentTools.clang_build_version >= 1500
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
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

    system bin/"ffe", "-c", "test.rc", "source"
  end
end
