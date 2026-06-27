class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "86c3ab03bb58efe259755db398962324e1401c1e2ea4c535fd47d236206e092b"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb1fe7b315e2159a2ec658ebcb255466d8e7934a9334e9d3f5137f3c334eabb5"
    sha256 cellar: :any,                 arm64_sequoia: "0b944ae9da22534f21126f7eca817ee4baac3aa17454f1722b3e25febd5969ae"
    sha256 cellar: :any,                 arm64_sonoma:  "d4831e62bddc6abcc76ce7680f9e3a2e3bbbc133ea4f76c1bbb879a14b8dd1d9"
    sha256 cellar: :any,                 sonoma:        "1b1fe28f3a2bc19f1941dbf6098c7681d0deaa9615257f71dd8f452c40f96b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb4c98302c9677a564272bf9e210ebd78236944076c502c8b3e6aad38b101be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb3d83d48ffe23b73c40800c6dda24994dabb7410447e79810e753afcbf156d"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
