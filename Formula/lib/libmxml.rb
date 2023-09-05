class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.3.1/mxml-3.3.1.tar.gz"
  sha256 "0c663ed1fe393b5619f80101798202eea43534abd7c8aff389022fd8c1dacc32"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69fb9bc4b6c43bed31c3d8b08a4202e2aa6a24abb1c9719e8a2a78feedead088"
    sha256 cellar: :any,                 arm64_monterey: "9c13d0bd3840b69d130cd1f4741f9936d7b2a90297a9925d1325682c143fb2f6"
    sha256 cellar: :any,                 arm64_big_sur:  "e5156d05dec405c83a198a997f668a3a92bdd9499220e7feffd46f4f4c1a4e19"
    sha256 cellar: :any,                 ventura:        "708c1042fb9ca17c2a37a8e6d96499f2a576c364e145d70ea7162247eee0771b"
    sha256 cellar: :any,                 monterey:       "f9e8125473110fef459d5d815a8e96e673815428eac1067f1e4b9c18d6c3aca9"
    sha256 cellar: :any,                 big_sur:        "e2d1dab5660d84e5647b01117b907e07b58e5dade826bd6f5859c7538cab2066"
    sha256 cellar: :any,                 catalina:       "5dd81ae17a13546014ce416999c1422d8ccb5129aa51f99dd0860d4836e24fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2a90260fc04202328638ea363fc8aa78e322e55f7b0eca1a7ad11d31c285e0"
  end

  depends_on xcode: :build # for docsetutil

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
        tree = mxmlLoadFile(NULL, fp, MXML_OPAQUE_CALLBACK);
        fclose(fp);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmxml", "-o", "test"
    system "./test"
  end
end
