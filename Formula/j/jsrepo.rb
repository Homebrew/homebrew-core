class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.7.1.tgz"
  sha256 "0dc9f26dc565df8630dba71ec6c7756d566ffe2eb057ea67b90d692d885910e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb85838c1bf5d8cbd209d330bf7d7b749c4befe0e178daad8d76c643f170de90"
    sha256 cellar: :any,                 arm64_sequoia: "14d44db6eff14d5f15358241e150031dcec18eabbb5d24c5d132044e2b22360e"
    sha256 cellar: :any,                 arm64_sonoma:  "14d44db6eff14d5f15358241e150031dcec18eabbb5d24c5d132044e2b22360e"
    sha256 cellar: :any,                 sonoma:        "a401f2d502cfaca281fe88f8e7512784be22b02d97291b9664daf62febf0a61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927038609836dee10b93b9f883f0fcef6ec9e3fad93df146055c162a027a6c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5942f9590b4a0f32c398ea9dd50efff76edb479ac2b4fcc1c93804f31e84d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
