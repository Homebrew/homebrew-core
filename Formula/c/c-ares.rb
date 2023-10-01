class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.19.1.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.19.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.19.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.19.1.tar.gz"
  sha256 "321700399b72ed0e037d0074c629e7741f6b2ec2dda92956abe3e9671d3e268e"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8cbe49f75ae85d59b427b7fc4e77374a42b058d724564b5cb1752c13f2dc40f"
    sha256 cellar: :any,                 arm64_ventura:  "ba35cc0962beaea7ae345ee1818297c40d5653649e563dc9493b93924b87ae41"
    sha256 cellar: :any,                 arm64_monterey: "de7817bc21be96a6ddc10a8f5c0dbefc7930b9d9a8bdca24ecd88c23d5e592ef"
    sha256 cellar: :any,                 arm64_big_sur:  "f8671b1156701b219b38544e7edab45a97afea17f06e5e2db4113d43036d1c2f"
    sha256 cellar: :any,                 sonoma:         "b518b634ec0bba43f2c6e4b76e6f6c900fa348d24af3114053214ab0f3871fbf"
    sha256 cellar: :any,                 ventura:        "504f6347444d599983e075211dee95529f7329324f3f7470914adebf06f46419"
    sha256 cellar: :any,                 monterey:       "c954838d76e0f11529f20455fa4173e5390a97479d141f3b6d2d136054a2453e"
    sha256 cellar: :any,                 big_sur:        "8e2a1fa105cdc6be5e40a16a32a21fee6fb64fbccc9826906e4097573c22b357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3705f6172017f6a8201a902a083898923ba3dc369889bc5572fd93564c3f6b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system "#{bin}/ahost", "127.0.0.1"
  end
end
