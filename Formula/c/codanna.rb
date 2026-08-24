class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "af37f30bdb89cabf656f4be9630def0ada284244d790d0b7fbda26447173b224"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1552ecc57fb27e18e3ceafa5d21c9dc9f40b1d030cd63cb6e94b4937e51c357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1b7e79f198a45d01bd832954854ea3d6e0468d053303ec6822f2d669b0f9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b15a6c23bbd50ea3cde476ac6069f2e36c038fc893c966df66e60442d22c4ef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0638d8400caac843f93c4dcc6cad4ffff57abbc80fefa55414db313aee60323f"
    sha256 cellar: :any,                 arm64_linux:   "1f5f4ef902dfe3a950bc135271fda5053bbfb743e933f259f1205edef16b104b"
    sha256 cellar: :any,                 x86_64_linux:  "938d0cc3556c204de257e81fdd408e9e7ab76f470f865dc8bd9f9bfca31ade9b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
