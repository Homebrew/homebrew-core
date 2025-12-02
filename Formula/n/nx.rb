class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.1.3.tgz"
  sha256 "2f41179b471913db9061a352cf22501bc44328c8b9954f47837603c0bab2087a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f9e667806f2c636d1b072d81381abe3503092f0b0ab475e0b3d6ca53fc08796"
    sha256 cellar: :any,                 arm64_sequoia: "00ae5a99442df861cc82b1c662074832d6cb87d86e449a75ddcfae768c78e1cd"
    sha256 cellar: :any,                 arm64_sonoma:  "00ae5a99442df861cc82b1c662074832d6cb87d86e449a75ddcfae768c78e1cd"
    sha256 cellar: :any,                 sonoma:        "e25b467d2f83971f56a3af9fe2fb84484f60e1d958e2f0dad49b65e2abe23b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dbc73010814693ce22032eb48694811a490d6574b3d09c6046377fad34282b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f52bba20b9a37514c5f215732d2fcdde445a705b43ca8f1aab700f3644a2868"
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
