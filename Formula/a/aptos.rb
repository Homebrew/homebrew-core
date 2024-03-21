class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.1.0.tar.gz"
  sha256 "d5e17fab1be16d0c1a666ca705b15214cdf54af9d9075ea19a271feb311e0a37"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caa9b2df8012c21b25dd2c92bdac629fae673eee26e6b953329cfa487e0238af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "695f59a8b741536d589e3c7472c930cfeb816fecc77080190a33d7b4c161e9fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df004329a307e93e324c462595783ecfa1c40e6e40a495ed42d4b411ff286bc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b73dff73fa2aec70157a3733c40b4dfbd96c1ce9b7fdde5eaf59805d7622e22"
    sha256 cellar: :any_skip_relocation, ventura:        "86ce28ba05d4b50507e7869341247228c2dfc79afa4f9978155495fafb0d45b4"
    sha256 cellar: :any_skip_relocation, monterey:       "53b9276e4bec5438803cc5ceae7d91fd46099cb7d98e755a3c6109df1fea8ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bce5d8503bcd9469dcf92b9b45eec8df7f9dd43a1e582c8b3e82783793a2208"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
