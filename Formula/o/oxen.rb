class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "76389b72ac30973a8493a0d8108fc542df105ff169f0709804b0744de60d8151"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db4c4d419d56753522f561dca92f7dc00ab2a407bcdabfa3681e3809ad79db1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75dd5ca80d4bee27d10987d0a7bf646a3e5e60ad79e22b303fd6e1f3aa681815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc68e272c4d40c6a512d7fb286c9037cd023a51ba4d90d192339a2c59a72e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "42af613bd2174922d478507f1f6ebe4918bec01e4ebe88e5cc9452e0061732c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe89473e857e0492f73be09558c43d14224189a865ae5f09b6c8148cb87a0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd94d0d9ecabe2fa7926ef4d9dc7826761ae1ecaadc79075774d62e07761324"
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
