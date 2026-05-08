class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.2.tgz"
  sha256 "7eb3adc552c4222116bad3dd7b26d61dacf451125d0b93c62b7123b884216b94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dab6d504b70cc3fd8870aac8fd1662437ca9af52fca8fa3b49c3e97ef4d80de9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end
