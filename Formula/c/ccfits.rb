class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/ccfits/v2.7/CCfits-2.7.tar.gz"
  sha256 "f63546d2feecbf732cc08aaaa80a2eb5334ada37fb2530181b7363a5dbdeb01a"
  license "CFITSIO"

  livecheck do
    url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/ccfits/"
    regex(/href=.*v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e095d123708d4f5c4c57b26c82155a75405f6e19f29c955ac7b52f4121d2df1d"
    sha256 cellar: :any,                 arm64_sequoia: "da6f787ac55d5f93ad25617af795ac878443371ca2bab55bf9fd64736d592cfd"
    sha256 cellar: :any,                 arm64_sonoma:  "057ee421d9fde174bd2e7dde06b8e72ed3c987c782f08e41f433d40025d31c0c"
    sha256 cellar: :any,                 arm64_ventura: "b0490e303998fd2eab1ecffd498b1fa052581b27d92b7cdde9265a52a4e713c6"
    sha256 cellar: :any,                 sonoma:        "a7d684bbb48a13f09a4b8e6d70228d2d06cfcfb975a52070e4e9adcc250f3a88"
    sha256 cellar: :any,                 ventura:       "512d95b2fae5a3be154661f93801a8ff9232c87e14a6284492fa74e053793f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555829bdb3662a54aca6af2aaf711c1c1ca388066e279f6bf725b2013bd23954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe8e6f44ecc655e7951eab676f718f070e76e4d00bbfca35c8e42478ae1b0a6"
  end

  depends_on "cfitsio"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # Remove references to brew's shims
    args << "pfk_cxx_lib_path=/usr/bin/g++" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CCfits/CCfits>
      #include <iostream>
      int main() {
        CCfits::FITS::setVerboseMode(true);
        std::cout << "the answer is " << CCfits::VTbyte << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lCCfits"
    assert_match "the answer is -11", shell_output("./test")
  end
end
