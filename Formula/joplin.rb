require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.109.tgz"
  sha256 "671b950d3f669c75478d9a164a77d45b50cd042f7d295f623de817b44e87cb39"

  bottle do
    sha256 "34134445067f13f2b041038a6e68bc3ee3dce49914a552c0f19dd10eeb917499" => :high_sierra
    sha256 "8f99a18e6436ab40eefb0cc29a33dd57558dd191b9fae0eb68dd7e94edfecd7b" => :sierra
    sha256 "1d72809c9bccf39f99cc90d75a60a13f57c9b9507d65028fbc4c824a312168b2" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build

  def install
    # upgrade the sqlite3 dependency to a version with node 10 support
    inreplace "package.json", "\"sqlite3\": \"^3.1.8\",", "\"sqlite3\": \"^4.0.0\","

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
