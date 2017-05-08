class DcosCli < Formula
  desc "The command-line for your datacenter!"
  homepage "https://github.com/dcos/dcos-cli"
  url "https://downloads.dcos.io/binaries/cli/darwin/x86-64/0.5.1/dcos"
  sha256 "9dfcfa2857adf0563765da2a1fc6f006fee3ec8b2ea9174efe7cbfb3822ca42f"

  bottle :unneeded

  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"dcos"
    bin.install_symlink libexec/"dcos"
  end

  test do
    system bin/"dcos", "--version"
  end
end
