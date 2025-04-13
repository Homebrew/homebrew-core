class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "1786772c8490fb513522319554dfb41d93ecae4fb35e1b70249f3fe3c75c6cc1"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a264e055e864eaac12bd6aaa4319c241ec4aec9d11f0498628ea355ed1fe574"
    sha256 cellar: :any,                 arm64_sonoma:  "88a641dbc9b421342f20d11a9cb5fd5e5f7ba73c7dc73548262d83ea026ebffc"
    sha256 cellar: :any,                 arm64_ventura: "b6013659e4c2b58a85154c37561c0411398cf4cf110f80c0403de328b602beb0"
    sha256 cellar: :any,                 sonoma:        "4823886c8e5743624206fc1ba979cffbc8becda48dbaf7c08dedf016985e05a9"
    sha256 cellar: :any,                 ventura:       "227ee91388879da2b90df699da6fedb7af4179fc184d123b910d79dfbd087c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb188bd4509aa99306c47c5b517ad9363aefc52454aa4e8a0882b9e78b800f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a51477be4ab6623346dfb2d55f8ec53d14c91f4bee616f26a2515ba4c087ca3d"
  end

  depends_on "cmake" => :build
  depends_on "libzip"
  depends_on macos: :mojave

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
