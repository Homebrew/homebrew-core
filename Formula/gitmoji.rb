require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.10.0.tgz"
  sha256 "50a7074c9b89ebfe9428961c752fa1b46bdee9a06bbf637340ca4c014248afad"
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

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/gitmoji-cli/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
