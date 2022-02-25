class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.20.1.tar.gz"
  sha256 "2cd909bdef561b480a536be20606a7617d19680e067c8d4a14d0f05fb6a0cd22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba1059a2936a8211e192651b2131c01121a3be0b83bfc79f72b66d906eb6390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "484e6587210b6b7a809b611d1f3c3f2c74cff7184f4fcaf1d5cc51e82a388579"
    sha256 cellar: :any_skip_relocation, monterey:       "0b8be851c5687b9a84b77b312dd70db62dab8a08678cd4969eb61745c4cfc57f"
    sha256 cellar: :any_skip_relocation, big_sur:        "43113ae8b15b9487cd7f49155a2524b7dcb58024e8dd77b1e1c2f7c4dc430ce2"
    sha256 cellar: :any_skip_relocation, catalina:       "9fc08666d5ddde105efb64f3182fef3321d0b44edf5b370dd3c681a5793ab996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b77ea0228b2645cc222cfc08e94b1221f9942535d85109ea324cd90edfd4460f"
  end

  depends_on "rust" => :build
  depends_on "erlang"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
