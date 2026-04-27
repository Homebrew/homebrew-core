class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.0.tgz"
  sha256 "874211bdd12ae4cd2d0dfef584997cba35f60c789b6c3921aa1f57e6503008f7"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da059b02cf81cf6d11c0976f3a0cc6e3d66a3e66ada8fba406dc19ea31e41e1c"
    sha256 cellar: :any,                 arm64_sequoia: "65048d5a7f501180f6cdbbc9d941af3a2613b4f405b96bd9538f6827f6bd8862"
    sha256 cellar: :any,                 arm64_sonoma:  "65048d5a7f501180f6cdbbc9d941af3a2613b4f405b96bd9538f6827f6bd8862"
    sha256 cellar: :any,                 sonoma:        "a6822f16025911049206adb32018f09112d635c6ea22d3f20c2e406d9a3a2152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463c2ad33c62ab90e5f54f22defa778e29a2e361f34363711d484d2a647351a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba57cb26f69b6b8fd58bd5181cddb0704cd5107021ccf82e40de8856b1dd204"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
