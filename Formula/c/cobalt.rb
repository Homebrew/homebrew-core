class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "a425be77478230b25f5c64431e82633a35d03dd6719bf740e4ae6624a69ffca1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7905ef78bb3e756be2089f0bf7957d77349548ca9252c023d47934b73ac990c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e49c03ac7d5cbd1b84aeaa2d00853edcebb901e5d2586abc9324f0f850ee0d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c22c2fe56beb9508ea4a8b17fde0b753d5e280cf7f9a6ed8f472fae0a3e2d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dd697c918d2ddeba21001a1137c4757000f61d608aea6fb6790dc580f24e0a3"
    sha256 cellar: :any_skip_relocation, ventura:       "07b06d6fa5007b9218cb3ac94bf33b70ac2ba1b277c77319570b1ec4964d8477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "302f4c25808c4f96f28439a3dbc27527f72864038387a7a6cf7a26d52018e897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe587ed78c7928e4d6d07b5943addebf8805f0818fa12f4aaacf2d972ea2db55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
