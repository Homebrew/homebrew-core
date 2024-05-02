class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  license "GPL-3.0-or-later"
  revision 17
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  stable do
    url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
    sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"

    # Backport fix for Protobuf 26
    patch do
      url "https://github.com/rizsotto/Bear/commit/4d9d4525cd3d1ad11761c79ca71645946f48e07c.patch?full_index=1"
      sha256 "be8ffbcb8f7562d70e16f724d2a91cffbd7e0b28b564dcafe46510a4b248bdea"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "1a78bff5e557ce160afa533464a19a092581a75d95ec989d55787a92de5537ea"
    sha256 arm64_ventura:  "842cb5b766ac3539e6023fc55583371b7fc727794a9be205be7750d3fb7823df"
    sha256 arm64_monterey: "2fbf1ef2a61d14ee72e112a68f04c203b3a71e347a2cb773193cbf1169e07e41"
    sha256 sonoma:         "2b62ffa223000525ece13d0de4e5f590309a810d3da183f6065cbcd0af4b7ae8"
    sha256 ventura:        "11a3b09160b6c7d6d21aa34d563755d0cae1e0c3e36ac2b42abdbe5bf7afc66a"
    sha256 monterey:       "e7a3927e5a6215a52adf488755b25ef091b8031174ab309d8e42cf430251b362"
    sha256 x86_64_linux:   "9e2728f567277a7b2cf0753be737efb998888b3755ca4dfb64a918e41f1f9f41"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
