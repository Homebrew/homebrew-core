class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://static.crates.io/crates/pngquant/pngquant-3.0.3.crate"
  sha256 "68a12bdd8825f9989f4ee9a6ab0b42727dae57728b939ef63453366697a07232"
  license all_of: ["GPL-3.0-or-later", "HPND", "BSD-2-Clause"]
  head "https://github.com/kornelski/pngquant.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "7bb45863272a81baeda8398132e02862643af78f1bc992eedc4c382efa1b8ecf"
    sha256 cellar: :any,                 arm64_sequoia:  "3ebc758f4e803c26bf87d7a0cb1d34b7e3048958e360eae18de7579f02eb081e"
    sha256 cellar: :any,                 arm64_sonoma:   "7304b28d6ac4803b515bc6d5f7a56115f993d0af414cc20173ac5e766e6b8dd6"
    sha256 cellar: :any,                 arm64_ventura:  "8fe4369e28cadb40f580f8788202124e9c8cecc8adf160422d941df8132b7105"
    sha256 cellar: :any,                 arm64_monterey: "c142cd5a58cbcc5dc2a642bd87ab7696dcd371c4c87db5138b8a54735adb37d6"
    sha256 cellar: :any,                 sonoma:         "6810c2738ecc54130198b31380b8fdd8629aab89a497e7bc456ac72417d90936"
    sha256 cellar: :any,                 ventura:        "e9a2a6f6276529634cf601eb2c15b257db31d0d7b5fab624ef6f4001af4faac9"
    sha256 cellar: :any,                 monterey:       "190bce955acdfcf9999a2dec7902d3bc1864b29eb2a2e636b3820fedd9ad81be"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "14ee8acb1241bb83143c700d424872923c8c5b158a1c4f797db43472c658263b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "088abd195e0063a9ff6f8b3e041f50c9cc08807c475ac573349cf47607519e51"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  # remove when upstream merge and release https://github.com/kornelski/pngquant/pull/418
  resource "manpage" do
    url "https://raw.githubusercontent.com/kornelski/pngquant/53a332a58f44357b6b41842a54d74aa1e245913d/pngquant.1"
    sha256 "831f485ccb3664436e72c4c8142f15cc35b93854e18c5f01f0d2f3dbc918d374"
  end

  def install
    system "cargo", "install", *std_cargo_args

    man1.install resource("manpage")
  end

  test do
    system bin/"pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_path_exists testpath/"out.png"
  end
end
