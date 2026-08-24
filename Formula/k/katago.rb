class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://katagotraining.org/"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "011a205c60c22f83008ba92d31f91196640f620edbfc2f09af79ef3f3311750c"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "650da5fa5faa80adf6b67232202e989e1a1c1b4e8babd13d8b05b581c0c011ff"
    sha256 cellar: :any, arm64_sequoia: "e5a2034b437f8aeabc4f887b71553bb81334d174ea07371f47ba0d3e25d8e440"
    sha256 cellar: :any, arm64_sonoma:  "879bf418f72256c80b1bd8fdd16342ba73eb707027aa3142b91d8f50736102a3"
    sha256 cellar: :any, sonoma:        "e0572e9a20f07c060943bc843cc3163663b10e665eeffb762a5b60c856dc2482"
    sha256 cellar: :any, arm64_linux:   "6c8f22022095d76bef65b0811969b1b9716f9f60a0998b508b60db579ae16e71"
    sha256 cellar: :any, x86_64_linux:  "0b109bd42e1956050b78864a0a987339509d3b62579595dc2fd6c992e56e3552"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  on_macos do
    depends_on "ninja" => :build

    on_arm do
      depends_on "pkgconf" => :build
      depends_on "abseil"
      depends_on "protobuf"
    end

    on_intel do
      depends_on "eigen" => :build
    end
  end

  on_sequoia do
    depends_on xcode: :build # to avoid build getting stuck
  end

  on_linux do
    depends_on "eigen" => :build
    depends_on "zlib-ng-compat"
  end

  # Using most recent b18c384nbt rather than strongest as it is easier to track
  resource "b18c384nbt" do
    url "https://media.katagotraining.org/uploaded/networks/models/kata1/kata1-b18c384nbt-s9996604416-d4316597426.bin.gz", using: :nounzip
    version "s9996604416-d4316597426"
    sha256 "9d7a6afed8ff5b74894727e156f04f0cd36060a24824892008fbb6e0cba51f1d"

    livecheck do
      url "https://katagotraining.org/networks/"
      regex(/href=.*?kata1[._-]b18c384nbt[._-](s\d+[._-]d\d+)\.bin\.gz/i)
    end
  end

  # Following resources are final g170 so shouldn't need to be updated
  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"

    livecheck do
      skip "Final g170 20-block network"
    end
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"

    livecheck do
      skip "Final g170 40-block network"
    end
  end

  def install
    # `quick_exit` is absent from the macOS 14 SDK; map it to the equivalent `_Exit`.
    ENV.append_to_cflags "-Dquick_exit=_Exit" if OS.mac? && DevelopmentTools.clang_build_version <= 1600

    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac? && Hardware::CPU.arm?
      # Reserve header space for relocation (executable is linked by swiftc).
      ["-DUSE_BACKEND=METAL", "-GNinja", "-DCMAKE_Swift_FLAGS=-Xlinker -headerpad_max_install_names"]
    else
      ["-DUSE_BACKEND=EIGEN", "-DEIGEN3_INCLUDE_DIRS=#{formula_opt_include("eigen")}/eigen3"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/katago"

    pkgshare.install "cpp/configs"
    resources.each { |r| pkgshare.install r }
  end

  test do
    system bin/"katago", "version"
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
