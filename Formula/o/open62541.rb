class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "da029a0960be24b8f7c157a5d373b50ebf7d238a5a33eca0820c7c04f47946c9"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92a3bb6c03051c00621eeb6d466d7ef0c7f44f37f5c157cb7f77388408b52cb8"
    sha256 cellar: :any,                 arm64_sequoia: "2b55146485987c5c541ea19d2245f25ceceeb71392cd87f12ea60043f12d094e"
    sha256 cellar: :any,                 arm64_sonoma:  "88c7c7c869959936991faebd47f67d77106aa844815a979a2508c82599363354"
    sha256 cellar: :any,                 sonoma:        "145f4305fdf0db0df90aacfc36b8bbf54b6e2b404162a8067558ff8e436a6f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de51e47f11c8297c63971c5b7191db777c7c178f2c8533baa49f9fcedd3d0bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29481f277538b6ffca39e94b8d057c8e8e07da7f705ed891addafed10bba66a1"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
