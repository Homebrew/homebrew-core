require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.11.tgz"
  sha256 "c11b0778c1885bad0193e7791190ded04610875029c5114db08387ff7461d304"

  bottle do
    cellar :any_skip_relocation
    sha256 "0db7ce915cfdc681971365af6562b89512203a0d6b307a56324cacb669e80687" => :mojave
    sha256 "ca88f69ce01606b89fb5f5aa3b9e21e6ad02e9219512d27a4a40699805f0841c" => :high_sierra
    sha256 "1e48c9ffe77b80476e8bbc89021e96a4532677cb3cf641ab10f4d559fdba55e8" => :sierra
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
