class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.9.0.tar.gz"
  sha256 "e6940b4d6dd631e88a2e42f137d12dc59babbd5073751846cabfb4221ece7ad0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9404b44b34c3f7703e589048338fcddd393e6c824cdbec0f6172e4c36f0fa041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97eb6290dfb369dd6c251dc830ecd9dd129f5d219d3a372493b1adda5fc6f0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a32816ab87bd9d69123ea1e6e2b289fee4ec32f5d4104d346a10ee509cbd22b"
    sha256 cellar: :any_skip_relocation, sonoma:         "86894e7f2f92664c32be55b1111531d89a7eb35e25c8ddc76b020412c9f80aed"
    sha256 cellar: :any_skip_relocation, ventura:        "9c97605fe9a9fbc44910d11a28ca9552d417d290bb02172076698325392d4601"
    sha256 cellar: :any_skip_relocation, monterey:       "b713dc6a1a904f878666dab2f9f928a5cd28ae4e7e17c5d1230925a277fd0048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "156601f9eac8c791257c1ed97d26f98497e37a63f3ff66152d5345fdfa17a53e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    args = %W[
      -DOQS_USE_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "test.c",
                  "-I#{Formula["openssl@3"].include}", "-I#{include}",
                  "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                  "-loqs", "-lssl", "-lcrypto", "-o", "test"
    assert_match "operations completed", shell_output("./test")
  end
end
