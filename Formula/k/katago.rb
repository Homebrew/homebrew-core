class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "51b1a9b48053b0de910f44abf2cc95160de7b6d43bb22300e0b80ea0b3ed0ca8"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "ca788bdfeb3514240e1c591fcdd996aa5f55b5dc83c8454caa81532eae5f77ee"
    sha256 cellar: :any,                 arm64_sequoia: "d2f5e090c380b977c953a151517b3e1c769bd251b1db88dff9a9bbdc0acf23e1"
    sha256 cellar: :any,                 arm64_sonoma:  "8617afbae0ac910f2e99019073442bb4daa93b97db7b06eb51be9ac23d77db22"
    sha256 cellar: :any,                 sonoma:        "fb01d1d449451165e36c66d243d2fd438b61899ea32971229fcc1b21a286398c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845e10c3bcde03fb13b7f32a2c33147032df5a75cade3e7b3e9bd8a12fb184d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f371b838c53aff816996bce34cb078be71e7487551c1f7946f2c18e40652cf"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  on_macos do
    depends_on "ninja" => :build

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
    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac? && Hardware::CPU.arm?
      ["-DUSE_BACKEND=METAL", "-GNinja"]
    else
      ["-DUSE_BACKEND=EIGEN", "-DEIGEN3_INCLUDE_DIRS=#{Formula["eigen"].opt_include}/eigen3"]
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
