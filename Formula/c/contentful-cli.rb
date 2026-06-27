class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.2.tgz"
  sha256 "8763c9bf7c45cbf953fd6be40309d9eef09034f1e2c960000ffa4401e74bd307"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cce42e59f4a14d22f72118b4578589f41cb48109ff0f4f81d4e501924840861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cce42e59f4a14d22f72118b4578589f41cb48109ff0f4f81d4e501924840861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cce42e59f4a14d22f72118b4578589f41cb48109ff0f4f81d4e501924840861"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cce42e59f4a14d22f72118b4578589f41cb48109ff0f4f81d4e501924840861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cce42e59f4a14d22f72118b4578589f41cb48109ff0f4f81d4e501924840861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba9e98a88247d83bba91518652ee2dccb779102ac6b147ef492e5694f72864a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
