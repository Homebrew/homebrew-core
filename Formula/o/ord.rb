class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.18.1.tar.gz"
  sha256 "cef87229084a25b94dc730ec5bcac755a9917ef0c41ba440e16ae9cc0185259e"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8365a2c40c59aebc963952d62a5fa51df8d1f11fafb9b155204822cb0213ac94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e3e14a959bedbcf3ca52e90bb16db5a0e312168cba198161370afed352430d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab097bac3b6e8df202f9f9809b7c3175a782f74af2f36d7c69a63c95e03a1614"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e57b507e34f73e5480aaa42a56c15afcf8d3edd6db7d0c6666a6ddafa2ee2f7"
    sha256 cellar: :any_skip_relocation, ventura:        "852fd1fd733c14d553c44fce078346d229dc5063e832bc1c67584e999367e72d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1e8b79424b5221d58ed9eccb7f6c26fcf07baf60dff4c5bdecc4457703d3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2fe4399397c428613bb62102e69f9d8aa235c26d42a5c2f283ee3d33c9dce0"
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
