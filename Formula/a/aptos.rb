class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.0.0.tar.gz"
  sha256 "381750d63488884e2784459b0c2387fd1838ee98e6b4c9d1a9d54044211c30c1"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910291c7f072ef934c9cdb969299e332e0f68dd7466802592f403017cb35745f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7233bf17cd1f585860ac9eb37331b13169c1842e07cf05132045704bc36154e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368c4d87c0b35cc2689c839edddcbffd6ff98314f68efd897570db7666caad2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a9375380a386a1cd06794f8cd383105c4f98b8b3cade401fed9e6c9089f86d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad5cec5ecc93022135aba848beab55bcfbbc0f804a477983c7ab68da47dbccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32831122b990de1cc7917706daa1145bb92879c3df32b610325d7c7ab657cca1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
