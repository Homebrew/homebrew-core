require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.7.1.tgz"
  sha256 "5d8a810c6c4486101dbbbe35cf7e4a6496ebff5ca24c5a9bf9a0034f09d6221f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3079379faf65ea6d5ffb2477094a9c6077b7e6a2dc1f354cdab541ca0e7b21db" => :catalina
    sha256 "93a76e6f1c1f8eb4aac1175662c7ce9e79e9fdea6880fa6444302efff96ffdb2" => :mojave
    sha256 "ad5a4d0dac69c963bdac1285d5e14849be4d05326e9186ef8a0f5c8c29d6543c" => :high_sierra
    sha256 "cfc5f8e5a40e478aec70f585d0a1c3edf86be824ed5d9d038d69edfca92acd07" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
