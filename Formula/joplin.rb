require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.124.tgz"
  sha256 "6da64d5ff859d2e6648ebcdc4e99486461db4eba13d4827f0261ac4d5be8de35"
  revision 1

  bottle do
    sha256 "7a0359eadd073092d70762acfff84f57f31eacea52224375ef027b142623d79a" => :mojave
    sha256 "3e47b2e6d743fba79503934d674b6185c610e39fb58d40f7a8596a107518aef1" => :high_sierra
    sha256 "81970b83217257790c1bfef47c224eb93a215eb8ac8f9619b3ac49c01ae5669a" => :sierra
  end

  depends_on "python@2" => :build
  depends_on "node"

  def install
    inreplace "package.json" do |s|
      s.gsub! "\"sharp\": \"^0.20.8\",", "\"sharp\": \"^0.22.1\","
      s.gsub! "\"sqlite3\": \"^4.0.1\",", "\"sqlite3\": \"github:mapbox/node-sqlite3\#723de4ca\","
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
