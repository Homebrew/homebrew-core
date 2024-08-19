class Libtickit < Formula
  desc "Library for building interactive full-screen terminal programs"
  homepage "https://www.leonerd.org.uk/code/libtickit/"
  url "https://www.leonerd.org.uk/code/libtickit/libtickit-0.4.3.tar.gz"
  sha256 "a830588fa1f4c99d548c11e6df50281c23dfa01f75e2ab95151f02715db6bd63"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtickit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51b38ea86c54e7e7066a4a647fb54a5ead901cad66351864fff9c13b7d7ad5d2"
    sha256 cellar: :any,                 arm64_ventura:  "977351edbb07a69bb5fd6e8ac66beea1c21079a5222a9d99cd8682ea3bf19869"
    sha256 cellar: :any,                 arm64_monterey: "62791be08577ec55964ae31b4773ea1b40f5e6eded04c5a7d53db91f9a4f6aa5"
    sha256 cellar: :any,                 sonoma:         "f8b70ed83814c613ec565f63c620a3a610d577351b82a88c43092d8607f70c84"
    sha256 cellar: :any,                 ventura:        "8e05bb158469669b22f12becd2ef300edee426be92d0bd32a0664bb658e77d77"
    sha256 cellar: :any,                 monterey:       "4b6947249116e4c22a74bd74ba2db83b5b66b31ef1efb2a732ea4783ea0baf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c521424137d6ff8325dd9baa8102c2ba32b2f3429a50998016d3931c69f9dc6e"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "unibilium"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test_libtickit.c").write <<~C
      #include <tickit.h>
      #include <stdio.h>
      int main(void) {
        printf("%d.%d.%d", tickit_version_major(), tickit_version_minor(), tickit_version_patch());
        return 0;
      }
    C

    ENV.append "CFLAGS", "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-ltickit"
    system "make", "test_libtickit"

    assert_equal version.to_s, shell_output("./test_libtickit")
  end
end
