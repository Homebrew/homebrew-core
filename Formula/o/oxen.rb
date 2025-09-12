class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "28524f207ed257fe4e75573068182c70ea8d6d62d1ec2bb0b33af96b7f6bd4ab"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa96612c3e08ea162bd8ab0ccbdf885f1bcc960782d4a0023fb44ceb27d5507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa335e6a2b2e7055edff9a5da5fa0cbda20c0d12369b329b17dbe715194afe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb9b6c1c2a03e0cf5a37ede1a92b0e7a944a85781e5561a9160493312e15c3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5916e6e95c88fae3cac66f9d5267c45a971e741b0ff69ec391ed0c50d7d45ef0"
    sha256 cellar: :any_skip_relocation, ventura:       "22bdc91f215bb87839f5130734d264682addb27948fb0153feee02be15418693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fadd9f21a229c0c6169b504d3b3c7f6298a1ea28824d95731f8b49a9145cf47"
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
