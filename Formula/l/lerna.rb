class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.1.tgz"
  sha256 "a74ac11fae962351a89489d96dd184f4063743c29371ee340d9eac7a4675606a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc2409c6d182a81caaf8adc14d7aa2f20079a9a3a7e80c6cccec66fee197e5a8"
    sha256 cellar: :any,                 arm64_sequoia: "24ff92417edd453c94196dd0d97a998a3f56593d6b9b00047414f7e689947857"
    sha256 cellar: :any,                 arm64_sonoma:  "24ff92417edd453c94196dd0d97a998a3f56593d6b9b00047414f7e689947857"
    sha256 cellar: :any,                 sonoma:        "4d78a944f3c9abcc90bc7225f26aa22862192a2abb664f79a485107e6024d0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c3ae846afd0c7edf8575e5e53a129e94590db236abc6902d9ac796d0db9c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d137fdb7ed2be2ae3289197dd4d5913b02bed7ac42626524337538a26212510"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
