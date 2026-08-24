class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v4.0.5/mxml-4.0.5.tar.gz"
  sha256 "28ecade70e3481e726907e79f8816b9e77d03cb810bccc8535a7a32bb08740c0"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63249105e541f275772497ee648662944489e4c48fb08ac49b2f2481ce6fc3c1"
    sha256 cellar: :any, arm64_sequoia: "36f1c25086b7d53bf920f27f4c545e1f53f72295defb904f8d6cba8983ac1500"
    sha256 cellar: :any, arm64_sonoma:  "3458a98b468310caaf60a7f969999af01ed2448cae6ac90f0203e74136a7da30"
    sha256 cellar: :any, sonoma:        "46708becd4693826a74064c96ce90b0199275dd26cba22608e041745d66dfad1"
    sha256 cellar: :any, arm64_linux:   "949838339c6eb13aff8235b4d31c27731107294358d7ca11b994444d4fbb6d08"
    sha256 cellar: :any, x86_64_linux:  "41c5022d54b96b08890c92cbd5994e70bf6264920e395edd7681d1ad42ac7e7f"
  end

  depends_on "pkgconf" => :test

  def install
    system "./configure", "--enable-shared", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, NULL, fp);
        fclose(fp);
      }
    C

    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    XML

    flags = shell_output("pkgconf --cflags --libs mxml4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
