class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.6.0.tgz"
  sha256 "210e637d9b5d8313542682515e160f05a2b38ec75b60daa051faa3fdf2a7b23d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4612d8c1939abc4b346006657182504187885cda852adfc84c5192d5b000a282"
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
