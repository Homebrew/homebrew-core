class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.2.1.tgz"
  sha256 "46fe1d2acba67453e242c4224cbb2eacac560050ae0a37bdfef23703ceceab9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb02df8ef52fe641f3169adbf2724939c1efb01593d00ee8ee5cb15b7ab1885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226d91dfcf30484728e9f901ec280b22a4c2c23275e15d5d53e415a77240f770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226d91dfcf30484728e9f901ec280b22a4c2c23275e15d5d53e415a77240f770"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3f33a127c18af0a9c484649cdc75e60f8ba7c3d788a6fe26fe94e7c7872e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65185bdbde58bedbe93177f8978fe9dc3801f99dbb4b1160260022d8340f20f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65185bdbde58bedbe93177f8978fe9dc3801f99dbb4b1160260022d8340f20f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/mjml/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"input.mjml").write <<~EOS
      <mjml>
        <mj-body>
          <mj-section>
            <mj-column>
              <mj-text>
                Hello Homebrew!
              </mj-text>
            </mj-column>
          </mj-section>
        </mj-body>
      </mjml>
    EOS
    compiled_html = shell_output("#{bin}/mjml input.mjml")
    assert_match "Hello Homebrew!", compiled_html

    assert_equal <<~EOS, shell_output("#{bin}/mjml --version")
      mjml-core: #{version}
      mjml-cli: #{version}
    EOS
  end
end
