class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-3.1.5.tgz"
  sha256 "65941649a92338aad8021fc0d0df1954b632f31299579f3e0ac72ef2a20a70d4"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af146437081cecba9865461d2e6e1ee4ba12e92683bbb4e130449bebdf8eda5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83fca618ae253e43b5e2eadeacbf8aacabe9cf992fa121079aae280c3e49b73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c83fca618ae253e43b5e2eadeacbf8aacabe9cf992fa121079aae280c3e49b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "905d47811dff6b131df4be72c72447986a391c610d9a8da7388861d95d048bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82175fdcc0139f8c8a2290533a0a8b70016a9a3a231a64efe862e9220d1a56be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82175fdcc0139f8c8a2290533a0a8b70016a9a3a231a64efe862e9220d1a56be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/@11ty/eleventy/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
