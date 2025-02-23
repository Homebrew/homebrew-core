class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v6.1.1.tar.gz"
  sha256 "6513f9df65bbb50f64e8bdb05bf726962ac9046d0ec0743a83e4fd8fa5cfd1f0"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3bee895237ed4273b6709e0f22e60ea747d082ca23511f72fcf1db5e03e296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a36572f08618e3e425b683fec2b6cedf717d2cb9a5165ca97106a34e5976f937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9ab2138cd9e9ce224c8b39e0bc7430969bd762985cf18bde50540a463275f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7b699fedaab41f11116632b289e07a81d53e99e1dd02190797b9ff8da1900f"
    sha256 cellar: :any_skip_relocation, ventura:       "092a177d997e317e088b9f849a0e4b12247af993bcf097709c696821a81ca901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5452be8015d69ab621dc34ab8eabb6701f3d19d04a66731e252faf96d4ae2857"
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
  end

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
