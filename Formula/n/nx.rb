class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.1.1.tgz"
  sha256 "1e6e55bcfc37ca266de75fb28423d34167eb705cba62675e2b63a2e5993d653d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebd3290363724ae799f852ae0646083a06a75f2200b8dd216f3e9a917f595ed2"
    sha256 cellar: :any,                 arm64_sequoia: "ebd3290363724ae799f852ae0646083a06a75f2200b8dd216f3e9a917f595ed2"
    sha256 cellar: :any,                 arm64_sonoma:  "ebd3290363724ae799f852ae0646083a06a75f2200b8dd216f3e9a917f595ed2"
    sha256 cellar: :any,                 sonoma:        "0a81a9b7c9f3b3d41dbdf5afb07bb6142791eda18d8e65de1c60f37fdffd5ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6221fbf577eaddd21264746e13784d72d9f7bbe1f2f10e77bba119718660f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4944a9f638b3a306b334aa0ed64ac29fd4d083594cf6dcc054b68dd4c2244344"
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
