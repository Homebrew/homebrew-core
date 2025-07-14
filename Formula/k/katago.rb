class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "3e9764cd9900a660ba2f87945167ed47fe1f38167498c91253ca865d00acf5c7"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e80dbbee12819f60c861a7d9048252c532cface8d4367b4ece1b24a5ba0259d6"
    sha256 cellar: :any,                 arm64_sonoma:  "b5ec08dfe190e1b4d612f43eb8d9bf1a1a4fbda057dc96b295a3e09afaa80314"
    sha256 cellar: :any,                 arm64_ventura: "348285893e9645c580b87a34b3443936a281dcc9d16bd94c519f432d173202fc"
    sha256 cellar: :any,                 sonoma:        "8963b88e6142f376f2928a8731c97acd485b971d107a30224ae0a002baf4a763"
    sha256 cellar: :any,                 ventura:       "89b5fbc27ad8b6e4a8c66748be2904dc1256275d120d34546a522913293c3e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e53bd33181b020ccca6dd389a2e77636c2fd884294ad60c52b5b7a85f69b2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144070674dae0dae56dfaaa2bb84db51211cbe4be65246dd2fc48d817160ce78"
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
