class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "3c18c52552e790358fbf58ff78f0dfbff5efd289f85114281c013e74fdbd0ac8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c916fd7f4dfac4187b37b97be84c0d6b2beff4f23d025048d9dcb4e211a5e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8da0fa577b06d6ae247f5b0a74adb2a8ace20cae2a74a44434c2b04aed5586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9099ee70a94c3a46854d24ca352d828ae2f8b7219d364474820dfc1f4e6c230"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc7224d60d0f8f7927df954dd8594103d4c2f81613fe15f7d5dae4195b3ccf95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b1433c3315c311168ba97e5c655b22e5ef48ca1a1707041f8cd8a1ef886995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5ced29b3c34f912144b798da159d4f743a615fcdfa740551e8f8e51b0ab80f"
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
