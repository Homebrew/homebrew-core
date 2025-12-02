class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https://emacs-eask.github.io/"
  url "https://registry.npmjs.org/@emacs-eask/cli/-/cli-0.11.9.tgz"
  sha256 "abf650008e51b200a8630e8e5e712dbe243999cfcfd631d0bb4c7d33fc4e2d83"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "199b090f591b6bc570de7b62b51e18bb1717b3902944ff1d637e0b3eeba3dfce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eask --version")

    system bin/"eask", "create", "package", "test-project"
    assert_path_exists testpath/"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}/eask compile 2>&1")
  end
end
