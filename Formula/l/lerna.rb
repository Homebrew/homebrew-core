class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.0.1.tgz"
  sha256 "82addf9fca6007e0cb504085038975fd78d6d3538529379c8162c832ce2da8fe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acd83ce4f07421043105ea98e1d5d48815d2b3fc02f8ed2a613e697d65b27da6"
    sha256 cellar: :any,                 arm64_sequoia: "acd83ce4f07421043105ea98e1d5d48815d2b3fc02f8ed2a613e697d65b27da6"
    sha256 cellar: :any,                 arm64_sonoma:  "acd83ce4f07421043105ea98e1d5d48815d2b3fc02f8ed2a613e697d65b27da6"
    sha256 cellar: :any,                 sonoma:        "99fe166264cc5c13574503b02038c987179c38bf91e437c6b62bf0c380c17823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e597b91a782760a6f503c72b0499652926251d50ba6f1faa01ffa082e5c7c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4a6226f6770d37453fa13059b67a092256e55d11da456d16bfc8bc7dd4ce99"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
