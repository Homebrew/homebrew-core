class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.4.tgz"
  sha256 "efa2086b8fcef6faa1966fb8bb88f7faf3f00b7b27d44960a922acf914a45be9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbd45543fbd4a9d000f377b5ce141808ddcfed5e4cb9ae89969571055f7a0177"
    sha256 cellar: :any,                 arm64_sequoia: "2ae99d84bca0419ae1d4454703e67d21521120615d19e9ace547fe1531004ca5"
    sha256 cellar: :any,                 arm64_sonoma:  "2ae99d84bca0419ae1d4454703e67d21521120615d19e9ace547fe1531004ca5"
    sha256 cellar: :any,                 sonoma:        "ffcbbc7724bff06b29dce5ef6c50c7d3c22dffa39935e94d417062a3e8e690db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf29e07420140e80dd7074a2e542e781b4b84c77f1ddbbeb1854f9491cfc522f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1588d3e032eac4b15ff8a63f4ee00a16afe57ec5387154df85b9689df5de7da"
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
