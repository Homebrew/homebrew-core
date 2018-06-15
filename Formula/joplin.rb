require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.108.tgz"
  sha256 "66152a8c3a847cc25711762740fdd22884ecd1df2347bd593ad977b4efad8407"

  bottle do
    sha256 "5291a8fac68615a2a28de3ef027d4e3d2ff04a437f50d2aa181e5ccfb1c9157a" => :high_sierra
    sha256 "019f59990164aafb1749adc8e45d3cf41c084aff57d061a05cb4b8922c316e0a" => :sierra
    sha256 "da2ec22078110635ead54355fa5e918da8db33f85973220ad8aa0ccb03126f75" => :el_capitan
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
