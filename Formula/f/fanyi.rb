require "language/node"

class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-8.0.3.tgz"
  sha256 "5798b84e26584878024fa5038defe3d1a33d5d600c95290b6c54d1dd8cdef421"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d601e555d930ee4c1b90402d837b802818772c142496e617a4dfef0ae9fd52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7728af46fdeeff0990e400a0bdecc76239094a19a4e0589ab1e88394fa3ce6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7728af46fdeeff0990e400a0bdecc76239094a19a4e0589ab1e88394fa3ce6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7728af46fdeeff0990e400a0bdecc76239094a19a4e0589ab1e88394fa3ce6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eed09616fa08706056055b7278afb90a6122ab549eb4f0b8d8e49b9f0b61e9d"
    sha256 cellar: :any_skip_relocation, ventura:        "4f43524726f3d282299f7a68b1c436f3d70f6be419cd8d4c9d41c1d58ee51b20"
    sha256 cellar: :any_skip_relocation, monterey:       "4f43524726f3d282299f7a68b1c436f3d70f6be419cd8d4c9d41c1d58ee51b20"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f43524726f3d282299f7a68b1c436f3d70f6be419cd8d4c9d41c1d58ee51b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e9d42993b45b6c5912408b174e2f520c3ed244da434e3c4e0d566ed3aceeba"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi --no-say love 2>/dev/null")
  end
end
