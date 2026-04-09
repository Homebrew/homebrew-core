class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-4.18.0.tgz"
  sha256 "c779ff8fd044f4f5f180d888aaacdf43e0a89694fc99ecfc89bb495d0715941a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87902fd3938393e70e7e78677fed61904738082fffb18a8818205c177290a75f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb7122a5543037147de096a1b87ee0026183bc6489d54b166f7c0c20d8a059dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7122a5543037147de096a1b87ee0026183bc6489d54b166f7c0c20d8a059dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe47603ac640bf64d7de52bc4a380e88f11d50f508ca9feb4edb3fd5f7490f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14ad0fb196104b141a64e28b4583463f2a3d5e92e38c1632515d15b854ee462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14ad0fb196104b141a64e28b4583463f2a3d5e92e38c1632515d15b854ee462"
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
