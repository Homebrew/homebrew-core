class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.0.1.tgz"
  sha256 "0af6934f8ef6cb26c19509e9757e417371ec1223bbe49ab96f96f1c0c65db7ef"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41f831c6b97ba464ece582aec3ed1e6fcbc6e6f5f3bfa91afbdc04ae1e682f22"
    sha256 cellar: :any,                 arm64_sequoia: "26a1f5d564e7c79254d8ba8b9088d5c6567077a5d64312ef249c18d017a1a2df"
    sha256 cellar: :any,                 arm64_sonoma:  "26a1f5d564e7c79254d8ba8b9088d5c6567077a5d64312ef249c18d017a1a2df"
    sha256 cellar: :any,                 sonoma:        "a42ae6378dd51385542b6c63ae06bfc5668baff4f2104fa1a5f613c55c074bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8ecb6a54605894016a4c274724b37c0e2bac177c58d1611820017fd3c0085f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c09433fbd8846af7038598415325e61a8f3886cbd6b62cb1078b02c6c9b1074"
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
