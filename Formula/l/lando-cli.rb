class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.25.5.tar.gz"
  sha256 "fdd2e55bb5ef3679257d541c1a079f68688d5661e6958c86bd4871f440f45307"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "a8162912b3182c59c3ad0cda5a4d4939b0e13e8944ec7c0bf49295161e9eef6d"
    sha256                               arm64_sequoia: "0462faed77467508036a3e711080a12e2604a8431a860ef8f760efd13e8ca85f"
    sha256                               arm64_sonoma:  "ce9746fc83090f533053636c5ca4c8f8105a5e01edd5a1df6f2576f9a9eb0614"
    sha256                               arm64_ventura: "3ffedd32aab715b7a1fd57e219989e0669809cb67619747b731efba50bd003f4"
    sha256                               sonoma:        "158eda70006df1c18372aa8c7f10f9a19eb693e9f0f454b4f899f3df5abb8067"
    sha256                               ventura:       "528d7314a6b3f5c28e23ec44dea03a5abe3b7784349d57bbc9244b4a2ec3d134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3caedfe8885fd71d09aa2dd9d7b6365139a66d509cafecf60cee3f8350b65a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3caedfe8885fd71d09aa2dd9d7b6365139a66d509cafecf60cee3f8350b65a36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", LANDO_CHANNEL: "none"
  end

  def caveats
    <<~EOS
      To complete the installation:
        lando setup
    EOS
  end

  test do
    assert_match "none", shell_output("#{bin}/lando config --path channel")
    assert_match "127.0.0.1", shell_output("#{bin}/lando config --path proxyIp")
  end
end
