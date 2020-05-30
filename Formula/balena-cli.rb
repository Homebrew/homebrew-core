require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.35.14.tgz"
  sha256 "c252307044a6268e0f712014402b1d51adc8f453619279519c8c047d077635cc"

  bottle do
    sha256 "55ade4bb0bad7e8185d21ce9730c8c293bd360024579b0bc4bc8c42d9b68c4d8" => :catalina
    sha256 "8324374ce0294014580df5e13ef434af583946dcc8f81b557e7099470aa539d8" => :mojave
    sha256 "76cb629f1cb9312cb7b920083579187b4e1ce1b6ee3c49d54276324fd2de24c8" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
