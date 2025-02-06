class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.22.2.tar.gz"
  sha256 "f270aff0ab7190800876b0a662d05b23e5de8aaf7ebfb77f9711260e2aaff3d9"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21cd44840862af5e25d1084191ac483ed8e5ab50ed3473e99ed583755ac7ea4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920ac53de2ae30b7f75b170e4bc9c5de420e55cdc72534f1b2201c41078988cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f7c11fc20a7211c838e2bb303bd45f176dd5eb8d2aa433e3cef22dc3172446"
    sha256 cellar: :any_skip_relocation, sonoma:        "03accef84d1c8ae8878c8097c22e00eadaf3f24df3c9e92608cd10414eb1f31a"
    sha256 cellar: :any_skip_relocation, ventura:       "8493150704ff4a1d784e1d71a8a35d5fdf0d8448ea9c7bbd74c39ec9e8ba5fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42836674782f3a94b51ca38ecb3eac52bae72b0eb7e665737a00ae845552df6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
