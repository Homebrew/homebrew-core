require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.125.tgz"
  sha256 "c41cb46e37549958a941c2e8af7d60ed667479adbbdfc8880e5158631b9c5ebc"

  bottle do
    sha256 "7a0359eadd073092d70762acfff84f57f31eacea52224375ef027b142623d79a" => :mojave
    sha256 "3e47b2e6d743fba79503934d674b6185c610e39fb58d40f7a8596a107518aef1" => :high_sierra
    sha256 "81970b83217257790c1bfef47c224eb93a215eb8ac8f9619b3ac49c01ae5669a" => :sierra
  end

  depends_on "python@2" => :build
  depends_on "node"

  def install
    # node 12 compatibility fixes, can be removed for the next version
    inreplace "package.json" do |s|
      s.gsub! "\"sharp\": \"^0.20.8\",", "\"sharp\": \"^0.22.1\","
      s.gsub! "\"sqlite3\": \"^4.0.1\",", "\"sqlite3\": \"^4.0.7\","
    end
    inreplace "lib/shim-init-node.js",
              ".resize(Resource.IMAGE_MAX_DIMENSION, Resource.IMAGE_MAX_DIMENSION)\n				.max()\n				.withoutEnlargement()",
              ".resize(Resource.IMAGE_MAX_DIMENSION, Resource.IMAGE_MAX_DIMENSION, {fit: 'inside', withoutEnlargement: true})"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
