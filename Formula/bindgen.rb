class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "3d268e74715c04719af51736a42d4127c9c353b4beaa218aa4e3ddbd4e86d59b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "098197d94076add3e7a4f9e2fa29c61b3d7c53e5cc864377e9c4445200ca29b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88f1a346d9e2415e26ddf351ba72027b946b06a70b5868be6f0af81516534f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5aded9d3920118fd714c4f6601af66707ef3708a041da784d1dafd5c1a79960"
    sha256 cellar: :any_skip_relocation, monterey:       "20fcec548585666f008a6a06584ff3e435015e9ef0616fc1634c201c2ad569ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "423e179d0b3955addf18d6e383688064c9da3968c761826e4708399b832aa3ac"
    sha256 cellar: :any_skip_relocation, catalina:       "49a18281c1e1b491ab2a36c7411da5e9238a367e4db2e7e5b87fdc4976a91e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2098447a570cf8b171157a564a03792f1ea4d475b333b9ab601e9b80a3afac28"
  end

  depends_on "rust" => :build
  depends_on "rustfmt"

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")
  end

  test do
    (testpath/"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output
  end
end
