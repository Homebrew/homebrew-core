class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "8325384f9b332c4a3c91b5fa8189f26b07e8febba4310654d0b1b5d69687a0f6"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc20e1e7c5dae5d19e845cde1c3d0497c71015ebdb13d36cff8f08741a4131b8"
    sha256 cellar: :any,                 arm64_sonoma:  "80b473d1a752d762306c4ddf263a5574050ed86d8cbaa89875e6a42361a08ceb"
    sha256 cellar: :any,                 arm64_ventura: "01459cd115f60ee3c8a6ba124960b1b489801542152b1b6d203c01f0713fa433"
    sha256 cellar: :any,                 sonoma:        "ec0f29e806f41a0ffa56b81f1c4352f46f2d7d82be5885a4a673372019c10047"
    sha256 cellar: :any,                 ventura:       "7746fe52f85d8de435e00b0199009f6684d9deb224b4346cf8d68b67e7be14cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deaa4b1012c15bb7d9bcd07bfe50c308ac13c31599d4463505981eda31e71b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2175bfc184bc703d0c92fda2a7c685b8b0079ebf71292d65633816f568047437"
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
