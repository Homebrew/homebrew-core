require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.19.0.tgz"
  sha256 "2ba203b98189abab6902e246a267be5952d7c4d273b984b0e3152e97e5db1c9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f4d82bcce87f942762b0d8a00e1eb3a90e313a1a7ab5f8cd834f90b68a740b0" => :catalina
    sha256 "c7b19a1d310a51fcc29469947a374df355b6f9d65a75d866176c94a8fd26f16a" => :mojave
    sha256 "6b48febb9bf6a2075c308228d139e8d52c2fbf9957f8d82ec3c6a46466d23e06" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
