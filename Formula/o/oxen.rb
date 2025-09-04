class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "bcbfb67838ce2b065dc968963431f2d18a3cab002613f7bd2ab0b670577e4d4b"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d459e4b90d2937cd6cd2042eb0a80d1ffc6020488bd0b4e5f31c138bc096c1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c76a5a8d2da738c23fedd839808c341f5eb59abd08b8c3eb4394d6cc841b20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c70971b26eb94b21e71ad6a1f7a696500c236b47b6315cb5c542f24bce0ceb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "79fb5793baca1c018dcb449a714ce9c403e92c7b89c17e581ae43941b1f6540e"
    sha256 cellar: :any_skip_relocation, ventura:       "9f6d30356b63854047399e24d3d2880408f2c75c488080f38a014f02adb224f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b58c632052f96adf88a95a1ccfe7b5d5e018148fd4f641dbe9d3085f3d7109"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
