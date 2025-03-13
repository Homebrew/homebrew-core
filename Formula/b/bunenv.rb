class Bunenv < Formula
  desc "Version manager for Bun, inspired by rbenv and pyenv"
  homepage "https://github.com/jonathanphilippou/bunenv"
  url "https://registry.npmjs.org/bunenv/-/bunenv-0.2.2.tgz"
  sha256 "365e198e793de7b9f0f2a69ea404e0e3db8e239e3826ae29d64035b8f7846671"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bunenv", "--version"
  end
end
