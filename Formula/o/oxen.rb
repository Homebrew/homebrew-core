class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.12.tar.gz"
  sha256 "464c6d21eb538b9b1e0f9917502e93ce05ee3317afeceb31408e02876e707c45"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b401a83a160dbec993dd85221d752ad5d8126112b9281b00e3a8d876286bf18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c968a2bf5795d127e835a2db2a9b0aa96037d10ac5be8f6d4931b6b2ce3bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c56cb751b11424995e524ecef2ed9610e19ec231e24785b573f41df8e318ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea397da483a1171468b62a9c9e6ffacdd85abae52366d2dbf4464699b91dc9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4298973642fad4e029d2b6a277c005027e40396adf1de31d7c563ea9b511f82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d38beef3b73af637c34299e2507fb54b9e95e0565fa50c1815791ff67406b05a"
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
