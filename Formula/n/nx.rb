class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.3.3.tgz"
  sha256 "1a41938d356f18bc10909fcfe5ea39b4c978c2ee9198b4673e1d76b00c39132a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e5ff0798721c7191140e053c2b423152cd948e61631eae5be84f0b4b7e77152"
    sha256 cellar: :any,                 arm64_sequoia: "604f848c6aaf1489130d5cb4480f8b62ec5cea90ac511e8b152558b5b3868d59"
    sha256 cellar: :any,                 arm64_sonoma:  "604f848c6aaf1489130d5cb4480f8b62ec5cea90ac511e8b152558b5b3868d59"
    sha256 cellar: :any,                 sonoma:        "f7dce3959e53220c12f9556ff9641c9af3b4ee9791400a49c33ef50d44ee1974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8fd0d5f15474290e4f86700458dc4ac89bde14c243333784ec04d5a703b3aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5513269b4849b65ef5233d8fd0c1b266333bb432528791df4b613bb0572b63a7"
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

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
