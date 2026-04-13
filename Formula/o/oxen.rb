class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.11.tar.gz"
  sha256 "cbd2a72193848e0c4ee8aed4948b2f2212c5b09d380f409f688f6e62a17ac8ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3b97dca32ea5c5ddebfad5a72eddeafc5b2274cab10761fb6fb06ed91850fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60de6cef4648e9a7bde2f350c4524e4300e7586e5bdde919eb2b7d4e78ac8c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6810c4c860a4153d4057e57c343441fc22ccf883aead092904015835b083807f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4815c03fd8381868746c7d6e05dbd8d13ecd1af5d808b1d68b739dbd6a267e66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50195c28643e8310d97de3c01651ed9cc0d50ad4bc5cf8cdfec95ba9e8072188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e41113c8854e2fb85c4d6e20dea3a0e911a942d3a1f3a0c703e1c761fcf0015"
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
