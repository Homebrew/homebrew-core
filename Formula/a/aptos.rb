class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v4.2.1.tar.gz"
  sha256 "5c90a91a2f587e80344850e9069702bc3384d907c8f748250c69834faa7fac69"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135468fad6882b3cc2b379c66db149fb4ccc9d8ed99a6e261d51ad89b6e14f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdd6d4aa10b9bb16b7ac84fa09dd13939eb06104364ff34066aee90b7f98fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "808b0e312e68fc2efc127953367dc674237df9cc467b762d92b351a786f10cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c4679cbd4f208b72cedc937cf5cfdca0a913a3b6749654f22870e41507a0f50"
    sha256 cellar: :any_skip_relocation, ventura:       "46e979cdce9c781c98a62b5ce3b1b8225fe790d4ed90c13d03f3073bc8bed474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80ec081b898546b8c9c765c48b3b59876168f81158c7891e61167a3e1a6affb"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https://github.com/aptos-labs/aptos-core/pull/14272
  patch do
    url "https://github.com/aptos-labs/aptos-core/commit/72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they are not additive
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
