class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.4.tar.gz"
  sha256 "175bf925ab580b19c4539053c88dd6e321a043a207ed0a98bc7f15c472571f59"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a928fd5a308249cb30a035c48c088188c2bc68bcf77f059debd064552fc12c72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f04a9ba11c57c30037b0a14c9db4f7c7083871166f6b1ae76a0fb9359977c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea8b5406023ae7d07c7e2e18c2ac4f4af3d38b7239b1d2314cf72fdbc226d390"
    sha256 cellar: :any_skip_relocation, sonoma:        "de5e0504956cedd8de689ce355abc6f08ba57e54408bc9e00f0f63beb43e8a71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317d7eca18490e6e040fe54e083aed44fcbf89904be066ba1ff71793ecf0308d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2995638196c13a53b9fef987ff368419c8d7a45112725f5b6f9cf58576bf635e"
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
      system "cargo", "install", *std_cargo_args(path: "crates/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
