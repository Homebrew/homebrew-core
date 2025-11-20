class Liborigin < Formula
  desc "Library for reading OriginLab OPJ project files"
  homepage "https://sourceforge.net/projects/liborigin/"
  url "https://downloads.sourceforge.net/project/liborigin/liborigin/3.0/liborigin-3.0.3.tar.gz"
  sha256 "b394e3bf633888f9f4a3e1449d7c7eb39b778a2e657424177a04cde4afe6965a"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/liborigin[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1caef54440a249705a29d9e068bd94c35355c410670286ed1f17d146ef8ae113"
    sha256 cellar: :any,                 arm64_sequoia:  "72deab19a18c880f934d4d31980bc5a302de0a5aa5b6f0d9108b8272770eb0e2"
    sha256 cellar: :any,                 arm64_sonoma:   "6b2321d3a34333dd2412625fb5710244eb6ec6d14b0dbeb920bfedc2be8a2452"
    sha256 cellar: :any,                 arm64_ventura:  "c03e70300f707b2eb9df6c967d9a57f7a2c642c6ab579e431586398959af7c7b"
    sha256 cellar: :any,                 arm64_monterey: "5cc7c81fa2c9f7c5e43a523c73ede1f85f50c2163d5ae177e89438f39f17379c"
    sha256 cellar: :any,                 sonoma:         "66b7d4f00528e398d6dac79c6f4bb4b851d0c6a6da36d9ad2a592a8fcb5566db"
    sha256 cellar: :any,                 ventura:        "cc73444b1cd2328a431f07471a2a1c91f7b5461fe9aceb8ca356f748e5099f95"
    sha256 cellar: :any,                 monterey:       "b56942f218b5c8a1c954fe63c4f440ab61c845bdab16b11aae95ab292ed28038"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ae477544a5737a1f8000896b2ad21d3806bad8b46150615074220eacd9ceb182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2bd55d4b555d79b2b215f8d543f9fb5b7c948d066fd8b5bcc42b869b932341"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <liborigin/OriginFile.h>

      int main() {
          std::cout << "liborigin version: " << liboriginVersionString() << std::endl;
          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lorigin", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
