class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.0.tgz"
  sha256 "f2256da67df5e85f8a286ee0dfabe7b78ebf470dafd3d6288828fcc63cfac5df"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d0fc0588d3cd2ed2b5aa8df70d26a0dade2926785ccff72fa868d85193f7395"
    sha256 cellar: :any,                 arm64_sequoia: "8e7ac601d183e990073ffc4f871059460e31221282053ce8ec01a0c4f693ebb8"
    sha256 cellar: :any,                 arm64_sonoma:  "8e7ac601d183e990073ffc4f871059460e31221282053ce8ec01a0c4f693ebb8"
    sha256 cellar: :any,                 sonoma:        "38c8753fa78ce19c437f3881abd0251b8e52892de683612b6bd5c66f1241e86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f79de4146a151ca60f586edd245f93721fe47ab0ee4b7ab8a039ee95ad93bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bfbf3fdb64b4d40b91477368166defdf1a14634bc148348ef043620e0c770d"
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
