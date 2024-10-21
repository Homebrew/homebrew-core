class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.21.1.tar.gz"
  sha256 "fd0c44e3e516e67f30665069e913cd6d87e149d3c9fa747a83e21b1fd9117bc8"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b72a0fa364ff3a4e99cd40ec161d179d71f10b0145a2b800e061e8883a7882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247bf797527e7009c6aa948c8f5aeab70de44aa65d6a259ffab27eb146ccbd51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9772ad559cb4eba5463a52ef1204d276e26bbfcdf4f1ced00f67b5b17102e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e12943f2bcd97726d603c267e6eb9d0409cb035fb7101f26ab9d0234459698"
    sha256 cellar: :any_skip_relocation, ventura:       "282d7ef89f86c133b986748e1afc55bcc4b29231f4dcd21e758f75d89417b38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6331a8341b3496664ffd46232a1ba45163698754b2b33b7fc2a3316eca7acea3"
  end

  depends_on "pkg-config" => :build
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
