class Libtickit < Formula
  desc "Library for building interactive full-screen terminal programs"
  homepage "https://www.leonerd.org.uk/code/libtickit/"
  url "https://www.leonerd.org.uk/code/libtickit/libtickit-0.4.5.tar.gz"
  sha256 "8f3d9ec4a8fcfa57425621eb21dc7c6cefc2f24b2a93d28db0ace9d1eab627c6"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtickit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4218e9b484e59347d3bfb008a4e5c8c5e57ca4210a71ca946f84d97f44fd7bc9"
    sha256 cellar: :any,                 arm64_sequoia: "51f8cb2afcb7f3ddf657cf19f3443d137d446f4cb507a5e9832321a978aaa65a"
    sha256 cellar: :any,                 arm64_sonoma:  "6ec0c3165a73423aa8e34fe65319418fb116768b7b71115341a1bcc4a5c6ffe3"
    sha256 cellar: :any,                 arm64_ventura: "c105a349bb5d28ea65b1ae84f6f1f8490cf6476ed5060b1b630ec95b9dcfa7ab"
    sha256 cellar: :any,                 sonoma:        "10dc3acf43ae29195233e836585da752b48e46e57baaea697217724309bfdfa8"
    sha256 cellar: :any,                 ventura:       "60e09a74122d538fbd5908b73325751ef74b7b4266785bcf7e34b00b2d6542c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d883629a90f2ff74a67fd9f0b7e0778cda2894d0b6e22887b164f500516a619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10701b8ac09fe1cd30ace8bad096ac9916b8f266a07af0ba162c8ce4cb0e8e7"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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
