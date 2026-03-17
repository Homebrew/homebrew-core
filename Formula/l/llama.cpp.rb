class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8390",
      revision: "b6c83aad55a4ce17ec96fced7770cd1be8758193"
  license "MIT"
  revision 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "435942c68d961e195a59621cee91e49cfa937ac1812c00c96688508ca78a7560"
    sha256 cellar: :any,                 arm64_sequoia: "155cc005b8ccf79674f92fa75418633548c644aec817bfd12ee1e9c3e7937e32"
    sha256 cellar: :any,                 arm64_sonoma:  "6bdfc0cd52b6498847cf2e1af63cf701f3e2eca73ed36ab6344881845ec914eb"
    sha256 cellar: :any,                 sonoma:        "8957ac522090bb015e0686b4c94f365293423acd71b337ff00dad98410bdac43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f10b93535d1cac703bba20fbd6ec8ea56362826980b658f4b35dcbc16e3fd724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db904193de44a14f2c5b5d4e2cbd10d25313127ea2df2ae30f3240cc4271580b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml"
  depends_on "openssl@3"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/test-sampling.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(llama REQUIRED)
      add_executable(test-sampling #{pkgshare}/test-sampling.cpp)
      target_link_libraries(test-sampling PRIVATE llama)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test-sampling"

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end
