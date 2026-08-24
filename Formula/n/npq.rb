class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.26.0.tgz"
  sha256 "00e2f33dd048fffff6c195e26af22ac2f120cc3f0a0f12a31b4b51042bc535ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ddb9f475dca17d73b2fe9b31807438f096b2f41ee34bd3bb42713bb620ecdde"
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
