class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.20.1.tar.gz"
  sha256 "a2086aa049b8bd21c880f23b21b0e9ef21d3c3829d40641aa8810c08be936c19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70c45cc56466e5b28d69ca52355d82a8b8be64afbff7269ef4475e7ada62b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6837d97dc37d9ffd1e0c84e974db7598f47db4a24099b8718019c7090b6c515a"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2b9bb793dae90f9dacc2f19dc0646576e364b1ca290fd558ccce1710411a24"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c9103225c2dd6c8faeb893947100bfb6395a0f6ce008f8968a2598fe99f3d46"
    sha256 cellar: :any_skip_relocation, catalina:       "7710d954067c99c7cace2bb0c58c1b7a61d88d5df1e997b95a050265ba13e4ba"
    sha256 cellar: :any_skip_relocation, mojave:         "bb72efd16f431bf09fa76661ed68b5919e6326f83da79d1f6e9d5e63fef90ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b59509fbad6bf50cd6b4d4bdf026f2e04772f0ec5ee8ae3d2282400a58740ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
