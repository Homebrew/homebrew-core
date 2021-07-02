require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.0.5.tgz"
  sha256 "5d336bb4425320e71ddfeeebd113d65ad4ab4b8e93db1ba54cf99d583a34d5c3"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34395deeb4da3aef5fcbd32f307eba2c0574dfa2262cabe9a7f414259d9f666c"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b1f6c49ec5a3498de567664228871ea4e564fbc79df93da7060a8b98445e4ff"
    sha256 cellar: :any_skip_relocation, catalina:      "5b1f6c49ec5a3498de567664228871ea4e564fbc79df93da7060a8b98445e4ff"
    sha256 cellar: :any_skip_relocation, mojave:        "5b1f6c49ec5a3498de567664228871ea4e564fbc79df93da7060a8b98445e4ff"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
