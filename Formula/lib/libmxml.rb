class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.2/mxml-4.0.2.tar.gz"
  sha256 "34ae4854c02f14007886d0fb0c50c09edbd3cc3f9a9267d6540823e4d617c8da"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51c423d17f639b8119139c182edadae6f03b6396e42bace9438174cfdbcd633b"
    sha256 cellar: :any,                 arm64_ventura:  "a51f3165f2490f0e9ea5a1b9138f19b4ee7b02b0d2f11da063c6f6ebd20bc20d"
    sha256 cellar: :any,                 arm64_monterey: "9b653c62ac38d583b6f30cb7e5c4e3c4a03201505f1dbd7fc1cde60c7f750341"
    sha256 cellar: :any,                 sonoma:         "bf422b6e058db039e42e98905e4289f1612e6d6c9e93bcd4a6516e3d712d9cfe"
    sha256 cellar: :any,                 ventura:        "e967cf791f84ec6477d449134cee53e839839e9d4c8d637fb0ff82d760d0c166"
    sha256 cellar: :any,                 monterey:       "98e1e1b8b65b2cabd74cd88dc9c6bc7c20b702729047bc80bb90a692ae8d4357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6a24684cff8e5c918895618ac73c3b80346312cc607d73e420fac281061f15"
  end

  depends_on xcode: :build # for docsetutil
  depends_on "pkg-config" => :test

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, NULL, fp);
        fclose(fp);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs mxml4").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
