require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-11.0.2.tgz"
  sha256 "1a4d68564a8f6874f0cdbf04723c800d078c69a37b7d8588a059f37c8acafa3f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc22acc7d408727d6f19246b52e14aba267860fd4d6e5ac2025e50755636ee84" => :big_sur
    sha256 "f0e3d16de650bcd069d5c9462c7300349b00d3eabd2c51255d49fb7c6ad855ce" => :catalina
    sha256 "9557bec53baccea0b76b019b0f53d585fcdcd9079a30ceb93accddb0f34eea01" => :mojave
    sha256 "acc4390688781e902fbdcc1fb0c6bac93546d371480ed0410c45fd63517c361e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
