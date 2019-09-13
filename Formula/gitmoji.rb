require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-2.0.0.tgz"
  sha256 "0ef8353bc2f7f75b1c4d3185563751510d8020ee0efc5299bdaa309e82b475bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a3c3cf923e77f16cbf0672b7fb0114ef03b734d72f98b637dc8df41a8657c83" => :mojave
    sha256 "61f3e7cab930bf48ad86f14f2b686f4297412fe942305cd2fd03a8a3a0b63f2f" => :high_sierra
    sha256 "4afe6c756226a46562c212bbae3ebbf4f67ac530b4c4267caf0773174896a963" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
