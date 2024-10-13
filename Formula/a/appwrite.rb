class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-6.0.0.tgz"
  sha256 "2e30ad57d2b93b0debdde67aae2996f29e77c82164ff8d335ec1ecfa7c5391e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6ee7a434b8b43e7ed20a91ab40df740fade43c3e13ed0b976395edad1c6b8cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ee7a434b8b43e7ed20a91ab40df740fade43c3e13ed0b976395edad1c6b8cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ee7a434b8b43e7ed20a91ab40df740fade43c3e13ed0b976395edad1c6b8cbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee7a434b8b43e7ed20a91ab40df740fade43c3e13ed0b976395edad1c6b8cbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec46bc84cc8bf0819d01714db93049ded7be0c6ec64f687b013ff5f6fb0a9542"
    sha256 cellar: :any_skip_relocation, ventura:        "ec46bc84cc8bf0819d01714db93049ded7be0c6ec64f687b013ff5f6fb0a9542"
    sha256 cellar: :any_skip_relocation, monterey:       "ec46bc84cc8bf0819d01714db93049ded7be0c6ec64f687b013ff5f6fb0a9542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee7a434b8b43e7ed20a91ab40df740fade43c3e13ed0b976395edad1c6b8cbb"
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
