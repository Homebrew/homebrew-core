class Libesedb < Formula
  desc "Library and tools for Extensible Storage Engine (ESE) Database files"
  homepage "https://github.com/libyal/libesedb"
  url "https://github.com/libyal/libesedb/releases/download/20260704/libesedb-experimental-20260704.tar.gz"
  sha256 "78f5e4cd11b551e673db270a9d40abf3c8ec8523b91939a9251ca80ee5a83bd1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e63439975c686ac79d7d641ea4c1e8784908e41034ff79bcc79e5bbde7b83d88"
    sha256 cellar: :any, arm64_sequoia: "6a7b88c41fe74eb4d9be40809121a31bd33eb137dc33ac50b15c1067e09b15b8"
    sha256 cellar: :any, arm64_sonoma:  "36ebfc0cb8c8352a72e164aa90b0cc202d38a3cc929714cea56901b3c8ed2d08"
    sha256 cellar: :any, sonoma:        "32cc0adcd218995ae9a7d899d271979575169f4019483a3da77dc943477a45a9"
    sha256 cellar: :any, arm64_linux:   "bdbb98771f0ab027a4604406da6bc8f78180b85beb72b1ca0348bf69e1b12e2f"
    sha256 cellar: :any, x86_64_linux:  "6e32f9d839bab70585e87cca6a6a6382697a4da6400a95dcd55779d9f586a1ce"
  end

  depends_on "pkgconf" => [:build, :test]

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esedbinfo -V")

    (testpath/"test.c").write <<~C
      #include <libesedb.h>
      #include <stdio.h>

      int main() {
        printf("libesedb version: %d\\n", LIBESEDB_VERSION);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libesedb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match "libesedb version: #{version}", shell_output("./test")
  end
end
