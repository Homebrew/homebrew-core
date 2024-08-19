class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cr.yp.to/cdb.html"
  url "https://cr.yp.to/cdb/cdb-0.75.tar.gz"
  sha256 "1919577799a50c080a8a05a1cbfa5fa7e7abc823d8d7df2eeb181e624b7952c5"
  license :public_domain

  livecheck do
    url "https://cr.yp.to/cdb/install.html"
    regex(/href=.*?cdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a7bad3e2c174916e5e286dcf7e7d576a9996f8f199cf001b91d8232e0719c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7516272a59a2e3f387bd50b183a2238d9c5333b788cd1f3484ca15ca3c198c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6641aee9a21258f66441e250aa172ea092731be3ead3ae1b85393188d16dd61d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9136d67f3a62785add35b9b205169b9ace86da2c86edf4fe1c16cb833465bf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "18e027480cd5c20f0bda1d96fbb527596dda5f724f910a8d5062daf16dc7defb"
    sha256 cellar: :any_skip_relocation, ventura:        "88b43291068dbbea67161b415370ea6d09c0663ab3ec8eb052ff02bb8df9bec4"
    sha256 cellar: :any_skip_relocation, monterey:       "6417a2118fe06cb58aaa4a1d8181e9192c6598b4b8712ee2e3fdba0537996aaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9684789ff31a9f66e863c5ddce337ddc056fbea3f2d321d5752a6ec00a3d88c1"
    sha256 cellar: :any_skip_relocation, catalina:       "055cbaab9c15fe3f4b29dac36558497937eea6643c8ccf0cc4a9ee2c427fcff2"
    sha256 cellar: :any_skip_relocation, mojave:         "49748511d9e05e7ae4158ca4e4bbf14af858686f0104c85240de06b2acfe9b9c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f187d9ff7ddb1a1532e83924d32d02521afc943738e4b21c79da5712340b0bbb"
    sha256 cellar: :any_skip_relocation, sierra:         "16b08929c8c42feeb2df4eaed5b46967eca487aaa20585dc5869ba44a28f0fe8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ac5a34c222875d86113275127632fe02ccc15c0332c7719cdac8321aa0f83bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39c6409d00f0176fd3bd2def3b15b555d5ea89d3b0f6dc9710f1ce61a442e99"
  end

  # Fix build failure because of missing #include errno.h on Linux.
  # Patch has been submitted to the cdb mailing list.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/515bc4f1322a1eb128d0e7a3a3db6544b94fc82a/cdb/errno.patch"
    sha256 "9116b3577b29e01372a92ccbdbfa5f2b0957ae1b9f42f7df9bac101252f3538c"
  end

  def install
    inreplace "conf-home", "/usr/local", prefix
    # Fix compile with newer Clang
    inreplace "conf-cc", "gcc -O2", "gcc -O2 -Wno-implicit-function-declaration"
    system "make", "setup"
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert_predicate testpath/"db", :exist?
    assert_equal(record,
                 pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0))
  end
end
