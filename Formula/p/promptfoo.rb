require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.57.1.tgz"
  sha256 "e37f803ffa3a3ea57b116c6b7fd84e958630ace179d504bc372cccd62d79ad65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63fffefcaf3889e7ea97b7f5c5dcb0fa9d29257108a30f8d92f4a5d0de9467e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acc0ef77a61f6bf22129a81d62a6c7ee270452d0521683551657e058d7e0c7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3543ff169450a0b37a3c9e5ce8b053a51960b13190b818933a4e20a9f1e5fbc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "033c1e241adc5f77c2f18c3cd8b1e52a82d6e9bac519508a0756c747babaa6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "df87d72ef7cd07361c24374184e8080c8c1e623cbac8a2ce924e8289d0cf6e53"
    sha256 cellar: :any_skip_relocation, monterey:       "c096c59a60600efeda56fb46daed2996a21e4989030a3e896252f08da02f1eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99f5151934ea6af22bfebe7706e9afc19c761e9b27af7a24176081b89179e898"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
