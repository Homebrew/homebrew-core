class Humanlayer < Formula
  desc "Get AI to solve hard problems in complex codebases"
  homepage "https://www.humanlayer.dev/"
  url "https://registry.npmjs.org/humanlayer/-/humanlayer-0.11.1.tgz"
  sha256 "97d596f00c74ff00adc04ae3f6f602b6bc4baf85a702e7ee7c67512504c686fc"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["HUMANLAYER_API_KEY"] = "test_token"

    assert_match version.to_s, shell_output("#{bin}/hlyr --version")

    output = shell_output("#{bin}/hlyr ping 2>&1", 1)
    assert_match "Authentication failed: Error: Failed to get project: 401 Unauthorized", output

    output = shell_output("#{bin}/hlyr thoughts status 2>&1", 1)
    assert_match "Error: Thoughts not configured", output
  end
end
