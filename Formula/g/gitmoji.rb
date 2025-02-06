class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.5.0.tgz"
  sha256 "b9c89644fac844f521afcdc2b31e57da7ac7e123df92d16c4fdf79190622a5b4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bbfbb3f96888616a56eaa944a5a1b2da387071659545aa8cca870797ed8f1fbc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    files = ["global-directory/index.d.ts", "npm-run-path/node_modules/path-key/index.d.ts",
             "path-key/index.d.ts", "xdg-basedir/index.d.ts", "xdg-basedir/index.js",
             "npm-run-path/index.d.ts", "global-directory/index.js", "@pnpm/npm-conf/lib/defaults.js"]
    files.each do |file|
      inreplace libexec/"lib/node_modules/gitmoji-cli/node_modules/#{file}", "/usr/local", "@@HOMEBREW_PREFIX@@"
    end
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
