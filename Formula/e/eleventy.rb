class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-3.1.8.tgz"
  sha256 "c818a912a1fa65ec2337ac5bbc43dc6dfb657e343f98a1d6f227fd5c6cf7a8ba"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f02e15084980c11ec300406f294a6b2eb63bcc4110558a036ef4b9995bd24ac7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f02e15084980c11ec300406f294a6b2eb63bcc4110558a036ef4b9995bd24ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f02e15084980c11ec300406f294a6b2eb63bcc4110558a036ef4b9995bd24ac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "046c7437fdacdac85801a69e59ec5f7b33bc434d17f4080fb98a2c78d5666e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "046c7437fdacdac85801a69e59ec5f7b33bc434d17f4080fb98a2c78d5666e15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@11ty/eleventy/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
