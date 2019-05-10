require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.125.tgz"
  sha256 "c41cb46e37549958a941c2e8af7d60ed667479adbbdfc8880e5158631b9c5ebc"

  bottle do
    sha256 "62beda24cd2cd2b33d51e30a1cc30aa6dafed3f6fe9dc550be602851aa10ebdf" => :mojave
    sha256 "41cba5161cac53128d62d1d32c91d1cc215e11ead231be421bef68817eb0eb39" => :high_sierra
    sha256 "53e066877ba15725e1af3f64ca467d43c03177351c7b78752f01575e226f6a59" => :sierra
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
