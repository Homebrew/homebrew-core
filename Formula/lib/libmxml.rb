class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.3/mxml-4.0.3.tar.gz"
  sha256 "3717da5b3829d6b37ef70db00ac1ec431bdb60faed8fde6538c11dc4aec13a7a"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20677433e3db005bc0e9bf9e7ea446a3158c8f6f0b86f707e133079cfe694b4e"
    sha256 cellar: :any,                 arm64_ventura:  "5ad6a10df96c847aad61c2c4fbd10d33b38a88b5861c6547f4aab796cf472c6b"
    sha256 cellar: :any,                 arm64_monterey: "f517bd3382d55b87d2ab9e20be36965d5291eacca9f0ee438fd60e42f34c086c"
    sha256 cellar: :any,                 sonoma:         "8036ceede48c460aa34f0f93dcf5d6410e304536cfa7e8829ea60f43d2d1ddf2"
    sha256 cellar: :any,                 ventura:        "fa29627b63ddfa60acddf91486e8ac23fdb148f5d694b179995c51b95945178d"
    sha256 cellar: :any,                 monterey:       "a573b42f65de7fa9e5f1d57f9548849895b6c28dcc0412b20a81fdf258eb1c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46e4fd4d9fd79ebeff1183abe4fca41d7d92698f418a9f01c1705c6b78b368f"
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
