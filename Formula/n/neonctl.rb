class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.36.0.tgz"
  sha256 "8bba627837e6202c0ea6348c32dd3b011a197aa25ca810c2d660ea580ea2199c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dad61498831b8ad34f166554df6e1e56db865f31b266d9e23d9014a1102a68c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dad61498831b8ad34f166554df6e1e56db865f31b266d9e23d9014a1102a68c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dad61498831b8ad34f166554df6e1e56db865f31b266d9e23d9014a1102a68c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b01ee116d59805953d8b351b7302a4f0585e638bc3951bfdffa531974540c7a2"
    sha256 cellar: :any_skip_relocation, ventura:        "b01ee116d59805953d8b351b7302a4f0585e638bc3951bfdffa531974540c7a2"
    sha256 cellar: :any_skip_relocation, monterey:       "b01ee116d59805953d8b351b7302a4f0585e638bc3951bfdffa531974540c7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dad61498831b8ad34f166554df6e1e56db865f31b266d9e23d9014a1102a68c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
