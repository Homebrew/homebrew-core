class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v6.0.2.tar.gz"
  sha256 "05138dd338a27c9de58a18a821fd089053c46e9d25894a169a745250b3cbae10"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e05e954a440478adc399a2897992895920442ac0e51e0428691598f8ed60e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c6d85b3b7b9bb250e4799e825a13bbc83cad2dc4af6abcf9102656b1d94026a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d416210e2050165215f4a3f85f4d1b65fe169b79ba1237b5ffe3ffab7a3a8fa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "79edbb266a9f358290fe4cc6e906eb83f989633500cb98d927e2fe009686951d"
    sha256 cellar: :any_skip_relocation, ventura:       "d6c1f1a821cde39ebe6ffdb02d42214de14ca08738be94afcee1d6109cc3f507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a7a50b7a82c716a776566bdd3fec4d41b4282fce5f4dfd16510dfb4f70684b"
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
