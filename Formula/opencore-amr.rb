class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz"
  sha256 "483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40cf41052489b327ddbce82d3883138cbd13e121acefcd0a86d2326405987322"
    sha256 cellar: :any,                 arm64_big_sur:  "0bba66cb88f85fa1bd81905d59e807d0329af2e1c0e2c9ccca6177116c7c1d58"
    sha256 cellar: :any,                 monterey:       "3bc66a9ce05f3eb3666b0e649af799980e44aaae3ed420b686dae15da553757a"
    sha256 cellar: :any,                 big_sur:        "cdde538ce64ce7ed1aa7fc0d5c023978307738a831d6fb8eb717d073b6b085ce"
    sha256 cellar: :any,                 catalina:       "424d294d95aa7539842f1c2402a0be6ba558fa22680a0f5681998b12cf45a152"
    sha256 cellar: :any,                 mojave:         "816d5463797b6412fd8944b98ab79d766dcf886b9eb37d83778fb7648d995603"
    sha256 cellar: :any,                 high_sierra:    "5f5f7853d97b957abb8671af372bd3a4a13191ccd135799cbad44aa3c66034ec"
    sha256 cellar: :any,                 sierra:         "2b6378d4427dc88bac7e01d2614dd100535f1d78b1e6b81560e3a074e1d5a770"
    sha256 cellar: :any,                 el_capitan:     "4b628ad01f725342698a8556c4176f5d57e3647cc0f52669092a0523b76cc5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6f7282d11c48774b6d25e1f25c6c768e3254e4f651eee42f04cec9977d199f"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <opencore-amrwb/dec_if.h>
      int main(void) {
        void *s = D_IF_init();
        D_IF_exit(s);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopencore-amrwb", "-o", "test"
    system "./test"
  end
end
