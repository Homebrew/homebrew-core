class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.82.tar.gz"
  sha256 "c2b30b29764321ba2f2be50cbeded24add03bc17a663a92825b1bce8a60ba24c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2679c879365d5385c2833d37469b4e68b23f033a88e1ee7fc894b65199eeed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384c45ef35a14321ec11e8de0940b8f7ce1dcf78f99221aacc61c12e70d8cb39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1899d17ec224e0d9381499ed1c45b76cefb49e6a9fb2c36ac09095a1587c29b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8978544d1715bb35ac3ba1008f8c35f24657809848762d1ba6763ec0e666c37f"
    sha256 cellar: :any_skip_relocation, sonoma:        "26b44bdeb0c056279e0d33784763085902559b0e886e956d6df31681105b594a"
    sha256 cellar: :any_skip_relocation, ventura:       "62e11efa74eb3ddf6889c89c5a8103091f676f3b0c879d8f9c76337cf2ea40dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaddb80359ab329ac866d56826ae40004d3b2c62d027a5637e275fde7bddc534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da07ee959c8519069c6846ded47178f8564265755851c1e65d794e03756182fe"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      print("test")
    PYTHON

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
