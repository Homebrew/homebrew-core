class Binsider < Formula
  desc "Analyzes ELF binaries"
  homepage "https://binsider.dev/"
  url "https://github.com/orhun/binsider/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a3bc10379677b19656436924f478798f205b371bc703feab938c1b2512f39500"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/binsider.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c11ab382fd297958dded8d9685f67fe756a24d97f528330dfae16a42d7a73dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f9f1ceef1fdc6d373fec4c8b36997e5914f1ff8e0679293fcef4cc5a2be2c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "761e347994471b3ce157f8b2ab46a4e3e143b529d6578b4585e1c3b593adf1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2902341e9a85d24a8a33a19f1da3d9f2512e20400b3b68eabba48fe2cce994e"
    sha256 cellar: :any_skip_relocation, ventura:       "a0be7f487c12b713227182a95cfd71fa74c8861c845f51af597402fdb2c85aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510fed2e6a9eeac3beaeb9ddd8e8446b5fe7188993bbd907746c864be9c33721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805569e73c84fb8455ce5125dcc9e188404c48ca88538917c82b5e4994c1258d"
  end

  depends_on "rust" => :build

  def install
    # We pass this arg to disable the `dynamic-analysis` feature on macOS.
    # This feature is not supported on macOS and fails to compile.
    args = []
    args << "--no-default-features" if OS.mac?

    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binsider -V")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Invalid Magic Bytes",
      shell_output(bin/"binsider 2>&1", 1)
  end
end
