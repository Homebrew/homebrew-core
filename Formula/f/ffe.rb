class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "https://ff-extractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ff-extractor/0.3.9a/0.3.9a.tar.gz"
  version "0.3.9a"
  sha256 "3f3433c6e8714f9756826279e249bcf7f7ab8c45b5686003764e44f63eb225e7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:ffe[._-])?v?(\d+(?:\.\d+)+(?:-\d+)?[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83fd52f2c29e71aa022e6be65813c2da6385204d65bd9f74e7568a5e6222068a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2434c37d7cd7a87491c114df6bda210f02931bea75a31f9dd5291124d3da0f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ac6a47505e5c5daea19a9e916141a3882896d1218815d8fb5d43fd90f75181"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7b77078513e21ac6d077c228a3fc51dc31dcdbb707e9807764b7438e6630146"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cd2f309d44bbc5d7a429d078f6cec664e4ec170e08b8993477000e7d843605c"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2a4fd7ab7bd26bcd4b562eb90e7ae78987bbd5c0ff387cac15e6dcf45fd0ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a4528a12f9748f4fae9cc5d1157a49662cea7dc3df9b9d26da970ab900e8fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cd58d701bdd204a70498b668326d01679493ccb77d8b84b517472d9838df0b"
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89" if DevelopmentTools.clang_build_version >= 1500
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
