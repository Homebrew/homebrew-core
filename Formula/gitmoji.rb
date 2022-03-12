require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.9.0.tgz"
  sha256 "e3ea6baed50e49cc59794b6d1f0e0d1a0b4b8573c2b468d05966acb7f1669a6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc9d96ff0d16a0957c13605748a74d8bd174193905ab41b87017f534f3a1ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc9d96ff0d16a0957c13605748a74d8bd174193905ab41b87017f534f3a1ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "8f550c136bb7c891e5d949c09a939b0f8f720e2ca78298ea1317f2001d4f2a24"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f550c136bb7c891e5d949c09a939b0f8f720e2ca78298ea1317f2001d4f2a24"
    sha256 cellar: :any_skip_relocation, catalina:       "8f550c136bb7c891e5d949c09a939b0f8f720e2ca78298ea1317f2001d4f2a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dc9d96ff0d16a0957c13605748a74d8bd174193905ab41b87017f534f3a1ff4"
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
