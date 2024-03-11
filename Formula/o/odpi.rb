class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "9e2eb3a10e4ab89691d847d5106cfcde8c1126b7959d3ee06076ea3f5b5a9d19"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab96a78fd44bfd65a6d0ab957dbe27b8762ccca3e0e3485929fdd543caa37b33"
    sha256 cellar: :any,                 arm64_ventura:  "c7e8d47a97008bd8e3656a7b83ee8ca59aa53b500a36b1fe485b2ad3fab73621"
    sha256 cellar: :any,                 arm64_monterey: "058f4575655ff97b7b5708f32326636c95979b2d5ebc4a25a30cd644fa985e76"
    sha256 cellar: :any,                 sonoma:         "988204551e0d72d566df331ff0567c78c55f88190b734b5d98b92db9080130bc"
    sha256 cellar: :any,                 ventura:        "4b340cf810d059cce2c048edf9b3fc1fcd4c68a8ebed4342cd8f2c2f77e87bfa"
    sha256 cellar: :any,                 monterey:       "00858db07333b14935a2673023da0bf2a05f0b1dc587de29a9a441bb42d74a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53448c6627369a3749d8346b15c4fa2c45e046384918c294aad270da12600516"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
