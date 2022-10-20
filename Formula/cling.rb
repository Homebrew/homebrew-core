class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      tag:      "v0.9",
      revision: "f3768a4c43b0f3b23eccc6075fa178861a002a10"
  license any_of: ["LGPL-2.1-only", "NCSA"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_monterey: "ae9ec74f889a58e57f00394e3b46dd1793d975ce7dc5907c71e2e15853610a62"
    sha256 cellar: :any, arm64_big_sur:  "82134eeea0ba90008355120b137908d828011e302b62ec97de10b152777d9651"
    sha256               monterey:       "90f4150c5bcc027fe76db2f53948eb31e757124da337639303eee2ac768c8999"
    sha256 cellar: :any, big_sur:        "e894d9476bc9ed0edb1ca8d3ca1d9fa6cefc8fc50befc93f1d1c25d1f1bee721"
    sha256 cellar: :any, catalina:       "fd178b38640189a9b096d9c98fe3b1dedc934a504ddc0d3dc1c6bbfea144f09f"
    sha256 cellar: :any, mojave:         "5135fc901ba316ca0e02f5598af21cd42a264994111252964f239b2576c7829b"
    sha256               x86_64_linux:   "315073c45b0684a970493476b9c8476ddf90eb7d69bd5326efdf97b79ec55e25"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        tag:      "cling-v0.9",
        revision: "b7fa7dcfd21cac3d67688be9bdc83a35778e53e1"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        tag:      "cling-v0.9",
        revision: "85e42859fb6de405e303fc8d92e37ff2b652b4b5"
  end

  def install
    (buildpath/"src").install resource("llvm")
    (buildpath/"src/tools/cling").install buildpath.children - [buildpath/"src"]
    (buildpath/"src/tools/clang").install resource("clang")
    mkdir "build" do
      system "cmake", *std_cmake_args, "../src",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DCLING_CXX_PATH=clang++"
      system "make", "install"
    end
    bin.install_symlink libexec/"bin/cling"
    prefix.install_metafiles buildpath/"src/tools/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
