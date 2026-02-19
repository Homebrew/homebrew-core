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
    sha256 cellar: :any,                 arm64_tahoe:   "7c13e987178ad35bd6e56312a3f472697b8d993488975eb41fa8db7c1e392970"
    sha256 cellar: :any,                 arm64_sequoia: "65eea9eb2209570606294c979ddf33d329b1898e5f5764ef3585a0b88a7ea9d9"
    sha256 cellar: :any,                 arm64_sonoma:  "1ec6ab9dc1aa73c2956b42f19be09ffa2df410c5fb5876e635d2e89e2d63203d"
    sha256 cellar: :any,                 sonoma:        "2de2a50d110cb15175dd881d703ef7ea97549ff93c1aefc4b90a8eb53141170f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0215b8f515978ffba7ef2d5c984baef1ddf9c73b591129e5072c7b91ccc45230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "520727c652970dbe2e280c4b93cf3d617e8357a7d330b49ceb428719fb79f626"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  uses_from_macos "zlib"

  on_macos do
    depends_on "ninja" => :build
  end

  on_linux do
    depends_on "eigen" => :build
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
    args += if OS.mac?
      ["-DUSE_BACKEND=METAL", "-GNinja"]
    else
      ["-DUSE_BACKEND=EIGEN"]
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
