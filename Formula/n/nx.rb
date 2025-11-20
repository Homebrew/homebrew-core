class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.1.0.tgz"
  sha256 "1978e10f9ae6437145d1ec8a92b3ee029a59e4085779d06503d16e7c9444dc99"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab08ff021c75c718629697a62034bd9bfb338a2e5c7bd680d81ed6ec10055aa6"
    sha256 cellar: :any,                 arm64_sequoia: "9b836247494b6742f5eaed1db3209f15c6ef37767d8e10da465ee077eb202234"
    sha256 cellar: :any,                 arm64_sonoma:  "9b836247494b6742f5eaed1db3209f15c6ef37767d8e10da465ee077eb202234"
    sha256 cellar: :any,                 sonoma:        "067ac6acd6e70b74f4ea0f45730c15d824d939ecc7dd3e87657ad5eec40829da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c41f3099b3e5c0d5a67252b2202c7d50eb597802981fb046b15d529cd6a841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf4dc8803adbddff003300155b916e09122876da73066cfc45151587524b5e0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
