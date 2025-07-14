class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.30.1.tgz"
  sha256 "781e2cf87b5a1854845a039223791c82c01d91f56dd7d7067685c968b2428a42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1812e40935d9b7cea275134282bb461f05b4dcdfa734bc4b060871e55507d389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1812e40935d9b7cea275134282bb461f05b4dcdfa734bc4b060871e55507d389"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1812e40935d9b7cea275134282bb461f05b4dcdfa734bc4b060871e55507d389"
    sha256 cellar: :any_skip_relocation, sonoma:        "167a642a4f255035474d9577be644d8aa03200aa7b295b74bd613354553e74bc"
    sha256 cellar: :any_skip_relocation, ventura:       "167a642a4f255035474d9577be644d8aa03200aa7b295b74bd613354553e74bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1812e40935d9b7cea275134282bb461f05b4dcdfa734bc4b060871e55507d389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1812e40935d9b7cea275134282bb461f05b4dcdfa734bc4b060871e55507d389"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
