require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.4.tgz"
  sha256 "77de0f138cdbc0cdf35ff0fe23cc79b4272db3f05cd34cdece00fffb8911b3f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "223ea219afcf3f60d2beacaf1411785cd50868b6f9a6c0a882e4b5fb42248ab8" => :high_sierra
    sha256 "a18d52466601e976170397475a109611db7f2271820a999c154e6b5fef5e5a5c" => :sierra
    sha256 "7307e99eec50966174ca53501a86c7112ae678bcfcea1264d2a8747ac28bf52e" => :el_capitan
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
