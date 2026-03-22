class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.3.0.tgz"
  sha256 "613717d6a2b4e34ff1c388d7f67f577af03bda6a902c990b0e04f0dc96136f03"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ada6e99ce41698be794489092c8d22ed752fef701ab2c6d9310cf73c6261cc8d"
    sha256 cellar: :any,                 arm64_sequoia: "0a5de02cbcfb868f392607ed1ba264a899f19316b13b643e8ced23af374e17bb"
    sha256 cellar: :any,                 arm64_sonoma:  "0a5de02cbcfb868f392607ed1ba264a899f19316b13b643e8ced23af374e17bb"
    sha256 cellar: :any,                 sonoma:        "27bfd74daefbc61957a200faac6ae71cb1078d899ee3f84879073367a7516673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11cccddb2fd8db58a45227ff4d0b8ac481e3a164b0c0b374d50d8babff3c3790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "425e28cea0f14ac9dbd24e41b551add460882fdea919ccae995dcff719f98ad9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
