class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://codeberg.org/tenacityteam/libmad"
  url "https://codeberg.org/tenacityteam/libmad/releases/download/0.16.4/libmad-0.16.4.tar.gz"
  sha256 "0f6bfb36c554075494b5fc2c646d08de7364819540f23bab30ae73fa1b5cfe65"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2f1263d0123e856bc3b10b59ec49ce8533a75f8bf46c9829a19a482134a8b33"
    sha256 cellar: :any,                 arm64_sequoia: "3f9a2384ea3a1c732897a5759b0a4c1dba5f3bc484e89288d7472f55ea1f7152"
    sha256 cellar: :any,                 arm64_sonoma:  "a46ffe14f2184a90ca8e60d0b30978cd673e9f943c55e9554bea0e7646e1f4f3"
    sha256 cellar: :any,                 sonoma:        "4e6025e114bad469457fd64a2710501afcdb3309c1d5c663cfccc90a9f7c37fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f504b4d003538ab8007b64bba565fee86f8610a7107bf682c6e72ebaea4f30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a05120955044b8c9a997b7084b5a08f5d913e5a48f7575ea72d4ff07cd620fab"
  end

  depends_on "cmake" => :build

  # Backport commit for CMake 4
  patch do
    url "https://codeberg.org/tenacityteam/libmad/commit/326363f04e583b563f63941db3cf7f50e76aceb2.diff"
    sha256 "8de5b7e7495ee789ecee07bacc93e2d2ce4be07c83e19c1181778d86fc7185ce"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DEXAMPLE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "minimad.c"
  end

  test do
    system ENV.cc, pkgshare/"minimad.c", "-o", "minimad", "-I#{include}", "-L#{lib}", "-lmad"
    system "./minimad <#{test_fixtures("test.mp3")} >test.wav"
    assert_equal 4608, (testpath/"test.wav").size?
  end
end
