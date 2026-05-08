class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "bc269006ea37b659f68ceb144f1f7e779b212a70b6e2c13c588c22fb2bd882d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68f441f57e12d8ae3593203d942e4983830c3b84e21251b6d50f0222e07b7a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c3fc6ba2cced0615ffdf18717e2c8e30724a5a7bc9cb5678d33bb108d46f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759448da501564145c1b54790982f938f259c7762abbb6d128b1c2e8e3e19a05"
    sha256 cellar: :any_skip_relocation, sonoma:        "035fffc51affe434e3c0bc02b52ed75acdc25a616bdc696d5ec9b58e33e2168d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4cb6a26dd2180314e11fe4d9bf086bd7af8642e120d38b03eb7b373cdb0987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89490195053a07d426a713caeb2494f361a55fb46dd7150b4cbd18eefdfdd142"
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
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
