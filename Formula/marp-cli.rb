class MarpCli < Formula
  desc "CLI interface for Marp and Marpit based converters"
  homepage "https://marp.app"
  url "https://github.com/marp-team/marp-cli/releases/download/v1.1.1/marp-cli-v1.1.1-mac.tar.gz"
  sha256 "1c5868581fd5e13b3e791c77f214f27cc3eca5b3d9a2dc342f89e521ff2798ef"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "marp"
  end

  test do
    (testpath/"test.md").write <<~EOS
      ---
      marp: true
      theme: uncover
      ---

      # Hello, I'm Marp CLI!

      Write and convert your presentation deck with just a   plain Markdown!

      ---

      <!-- backgroundColor: beige -->

      ## Watch and preview

      Marp CLI is supported watch mode and preview window.

      ---

      # <!--fit--> :+1:
    EOS

    # make html
    system "marp", "test.md"
    assert_predicate testpath/"test.html", :exist?

    # these do not work in testing environment
    # this seems to be a Puppeteer issue

    # system "marp", "--pdf", "test.md"
    # assert_predicate testpath/"test.pdf", :exist?
    # system "marp", "--pptx", "test.md"
    # assert_predicate testpath/"test.pptx", :exist?
  end
end
