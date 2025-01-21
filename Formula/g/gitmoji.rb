class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.5.0.tgz"
  sha256 "b9c89644fac844f521afcdc2b31e57da7ac7e123df92d16c4fdf79190622a5b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d17cb63128d034310085647bce373ccf75c4649c7ab4ba07a396f10767d7de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d17cb63128d034310085647bce373ccf75c4649c7ab4ba07a396f10767d7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d17cb63128d034310085647bce373ccf75c4649c7ab4ba07a396f10767d7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "f37602e394aafe7488073a86ad39ea4bad7b61672b752980d8448dc05a7140bc"
    sha256 cellar: :any_skip_relocation, ventura:       "f37602e394aafe7488073a86ad39ea4bad7b61672b752980d8448dc05a7140bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d17cb63128d034310085647bce373ccf75c4649c7ab4ba07a396f10767d7de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
