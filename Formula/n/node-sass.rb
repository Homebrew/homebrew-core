class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.71.0.tgz"
  sha256 "f6d052ffa4fd70b0a81ccf1e27b4c8d741802ffac66cd499eac13b00be4b0924"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, sonoma:         "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, ventura:        "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, monterey:       "57d6290d7c5c30f57992b463222e17c0ca8b3df19c424059def6ad8c2ce4e075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95219b9ad20a734b068e032415755d16fd53fc255ddbfd3cb9d2154738880adf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
