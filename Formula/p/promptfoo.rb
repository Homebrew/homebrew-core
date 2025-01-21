class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.11.tgz"
  sha256 "40fd10c4d7fa71ce8cf643235b755d69334cfff36ad069d272b6346c01ab248a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d435dc86bf9cfc8aa09b686fdda5f374a0a723c19a35571a0c034ee0098c2261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49b9712a7776b86dcfb0ce1b9190822c77f4240eb2d5cedc4ad797b4e6b14bac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39fb45b7dcb65f7e12505ab37a2693820a40ed59a53ba48d77f781a8c511459d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee68110d1778e0ba33c394f0fbe844ea583db8fc8755eb36f8dba2ef575af0bb"
    sha256 cellar: :any_skip_relocation, ventura:       "aadde1b1f122db08548435bbdbd73d754d9bbe61f0ed02a4bc14e2f3d5f1db9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab932f8439c7df379151b9f7d30bbda2b3454b3f13ebc4af53de7d276f9bb60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
