class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.4.0.tgz"
  sha256 "c766efae30aff5c2b69cf2ac08b6f3e27c6f4a48f5ea2df5fd42b302481aa2c1"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b738a652b4d9f4e68732920adc0b67951cd3f32b3b7e6b230c043077644810"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63b738a652b4d9f4e68732920adc0b67951cd3f32b3b7e6b230c043077644810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63b738a652b4d9f4e68732920adc0b67951cd3f32b3b7e6b230c043077644810"
    sha256 cellar: :any_skip_relocation, sonoma:         "3022a0cf0ac918b7d4f3aacae63401e398002cb0504796ff938487c0eabe866c"
    sha256 cellar: :any_skip_relocation, ventura:        "3022a0cf0ac918b7d4f3aacae63401e398002cb0504796ff938487c0eabe866c"
    sha256 cellar: :any_skip_relocation, monterey:       "3022a0cf0ac918b7d4f3aacae63401e398002cb0504796ff938487c0eabe866c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b738a652b4d9f4e68732920adc0b67951cd3f32b3b7e6b230c043077644810"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output(bin/"commitlint", "foo: message")
  end
end
