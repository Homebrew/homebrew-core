class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/v5.0.1.tar.gz"
  sha256 "33fb553af4bf1efe2defbd20790d7438da9fcf3b9913a37ff64e94c2f7632780"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3f5cb7da995669bac9facc95c04a53c532b0bd5ca80b6563717951bbd4aa76da"
    sha256 arm64_monterey: "39b23431bc1fa1da7a5dd79ff3a07803153decfd73b3f7dd352f4b24947eb41d"
    sha256 arm64_big_sur:  "e5a0031275fe907169e1bfbd833bb2b8187df71f34c7893623a24fea1ad1815b"
    sha256 ventura:        "fd67814524107813af505f2afd143e35c3a2cdd6332dd5edea139b853d9ed83a"
    sha256 monterey:       "e9f324ac4b195572b4d9be10893413dd525461d04f43d559b439282d1dfc07b6"
    sha256 big_sur:        "c278a830adf6263390b3fc73c97e44d2b5afdf088f48a6555d92996791a39a5b"
    sha256 x86_64_linux:   "9baac881839d7f4af8d1e3a0407bc3064a7d41e22a0040c8e03ffeeded2a4bfb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                                              "-DBUILD_SHARED_LIBS=ON",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
