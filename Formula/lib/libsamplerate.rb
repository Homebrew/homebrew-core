class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "https://github.com/libsndfile/libsamplerate"
  url "https://github.com/libsndfile/libsamplerate/archive/refs/tags/0.2.2.tar.gz"
  sha256 "16e881487f184250deb4fcb60432d7556ab12cb58caea71ef23960aec6c0405a"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a5245adca05c76e8f9593494b5909903ffe44c5173b7b713b6c5dec75005953b"
    sha256 cellar: :any,                 arm64_sequoia: "d51907988e3ab62f6e49ddd1253a723fd5964b78a0361453e8d9b75a2106b4e7"
    sha256 cellar: :any,                 arm64_sonoma:  "3c6892acfead8a6b32ede92a5f1eb1d4a4dc8a75e6c295b469875d50ec05e019"
    sha256 cellar: :any,                 arm64_ventura: "e3503b414dc2371bf89d19291377b45241255a4b538d81912c228c84a170bda9"
    sha256 cellar: :any,                 sonoma:        "6c59b98bd83a71ff444c2cd2a480d78459244174fb8ec7234ba9438b03ca53d5"
    sha256 cellar: :any,                 ventura:       "dac109c36e9c06cb12473b9eb767e44bbd0330f18ffdcfbb77af7574038eb7d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db3ed51b5ddf4558e0e86efae945c98fb2d2040f3ce614f39737bcbf6cadccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1223ba0942433dd6c68ce167723d32e2e40ee2f454054001008d487a8256ff6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  # Fix CMake deprecation warning CMP0091 (prereq for cmake 4 compatibility fix below)
  # PR ref: https://github.com/libsndfile/libsamplerate/pull/180
  patch do
    url "https://github.com/libsndfile/libsamplerate/commit/e4a0ab46887029e0f65f145ba3987cc592f18200.patch?full_index=1"
    sha256 "0826fb59d733188645f3dc207c938580970700381b9bc87058b137723cb30bba"
  end
  # Fix to cmake 4 compatibility
  # PR ref: https://github.com/libsndfile/libsamplerate/pull/225
  patch do
    url "https://github.com/libsndfile/libsamplerate/commit/1abc639420b2df8b9ff2e0bdcc28cf6613c7c0d0.patch?full_index=1"
    sha256 "b6fb61c763a0f072ef2ebb3a311037d2429a5e294141f6d5e552ccd25efabdc0"
  end

  def install
    args = ["-DLIBSAMPLERATE_EXAMPLES=OFF"]

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/src/libsamplerate.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <samplerate.h>
      int main() {
        SRC_DATA src_data;
        float input[] = {0.1, 0.9, 0.7, 0.4} ;
        float output[2] ;
        src_data.data_in = input ;
        src_data.data_out = output ;
        src_data.input_frames = 4 ;
        src_data.output_frames = 2 ;
        src_data.src_ratio = 0.5 ;
        int res = src_simple (&src_data, 2, 1) ;
        assert(res == 0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{opt_lib}", "-lsamplerate", "-o", "test"
    system "./test"
  end
end
