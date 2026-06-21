class KodeCli < Formula
  desc "AI-powered terminal assistant for development workflows"
  homepage "https://github.com/shareAI-lab/kode"
  url "https://registry.npmjs.org/@shareai-lab/kode/-/kode-2.2.1.tgz"
  sha256 "26979190fed850c0811d81e40bc4cce6402a7b2872ccc39a36c37be94e77df4a"
  license "Apache-2.0"

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    libexec.glob("lib/node_modules/**/fsevents/fsevents.node").each do |file|
      deuniversalize_machos file
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/kode --version").chomp

    system bin/"kode", "models", "export", "--output", "kode-models.yaml"
    assert_path_exists testpath/"kode-models.yaml"
  end
end
