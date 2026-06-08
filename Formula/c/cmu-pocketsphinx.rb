class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "e2db414eb66618cd0a98de77507db32517a48f6900b06bfb94c0acc4bef5761d"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "792f0965643344363ee3ab76f068c8633cae73cd28d0080ab00012d9c1dbae6b"
    sha256 arm64_sequoia: "c275bee65e898f179fd26ecd182d104fe95f6d0652248a2f705d0746c79fa213"
    sha256 arm64_sonoma:  "7e5207df6dd682d742400a0ea9bf8bf52a742ce62ac9aca7fa5d03b87e91e593"
    sha256 sonoma:        "e46da85fd4baf44fe79b3d636894b4ac0082055126a2ad27f7cdb79e864c74e7"
    sha256 arm64_linux:   "e531267b75c1c0ad734742b05be823681fccacb44e7c8c5ad61da9affa2067ca"
    sha256 x86_64_linux:  "c704bb2840ea6077529e273c98a0f5ad800bc056a1948bf35a4f501ea653e243"
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
