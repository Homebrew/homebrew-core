class LandoCli < Formula
  desc "Cli part of Lando"
  homepage "https://docs.lando.dev/cli"
  url "https://github.com/lando/core/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "b9b3cb2fc3e7a941f944f25dfeb7cdf8d02bb3fd164997acf22864dab8d4017b"
  license "MIT"
  head "https://github.com/lando/core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "5042548556cc4c290eb5bac07e300e3f26b01e3371c484e8ad21eb7ca6788181"
    sha256                               arm64_sequoia: "b9a8e2afce5a1a7d3bd6fcbbfc7d0c5d55e65e0022cba468eb91ad835c88dc8b"
    sha256                               arm64_sonoma:  "022a58faace19fa7e3f7d86d843be9ef428637f7901d0164defb371869c78cdd"
    sha256                               sonoma:        "78b51db437725478d963d89911bf6b2c227296d682dd17ff26c7b0079140910b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91b3e3ab9dc9cf9a16ec784a84dc469996adf887ffc771ed2c9dbc5878a81bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91b3e3ab9dc9cf9a16ec784a84dc469996adf887ffc771ed2c9dbc5878a81bc"
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
