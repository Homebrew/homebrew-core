class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "8e71983761b08c65b15b769b3ec1d980036c461fdfd415c7183378a4b3eac8f4"
  license "LGPL-2.1-or-later"
  head "https://github.com/hyperrealm/libconfig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2aba8caea48796a25a27d4096e8815ac2504b89cce8f9d5338b370a59c47986"
    sha256 cellar: :any,                 arm64_sequoia: "ebaf461f4cbeec58dceeec947802aff7ad7aa909f8197b0d3441f3a2604d6897"
    sha256 cellar: :any,                 arm64_sonoma:  "9ffaa431732a3806799bfa22dd3b7270cde21f535987a65a083e408d1e01491d"
    sha256 cellar: :any,                 sonoma:        "87545a69b32f537dc0e1c3c91009b6266007739e06bdddd3e2de4d3295e708f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e0bf4cd0d19b56a595c906370f714f71489d3b823399750e7fe2045d186f84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d07d69996141d177790414cdfac85da7c40d714a0d3343475c7748b196ad5f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    C
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
