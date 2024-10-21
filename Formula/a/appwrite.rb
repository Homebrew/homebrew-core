class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.1.0.tgz"
  sha256 "9075b1d772b6ead948cb20af775231279ed2969b005e8c0f6d850f318a90f28e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f39a860b0244bf0a644dfb85ad21c650cab8eb9a67f0bb446846d70552be2bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f39a860b0244bf0a644dfb85ad21c650cab8eb9a67f0bb446846d70552be2bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f39a860b0244bf0a644dfb85ad21c650cab8eb9a67f0bb446846d70552be2bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d3ca501f01c4cd9dd2b4c68c904447a00431c64ac393ef5d2b955626fdb81f"
    sha256 cellar: :any_skip_relocation, ventura:       "43d3ca501f01c4cd9dd2b4c68c904447a00431c64ac393ef5d2b955626fdb81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f39a860b0244bf0a644dfb85ad21c650cab8eb9a67f0bb446846d70552be2bd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
