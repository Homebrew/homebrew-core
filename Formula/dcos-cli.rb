class DcosCli < Formula
  desc "Cross-platform command-line utility to manage DC/OS clusters"
  homepage "https://dcos.io/docs/latest/cli/"
  url "https://downloads.dcos.io/binaries/cli/darwin/x86-64/0.7.9/dcos"
  sha256 "76348daa5d0b9c79a279d9d4fe109462548cd659442d021f4af69bcb40da6fda"
  head "https://github.com/dcos/dcos-cli.git"

  bottle :unneeded

  def install
    bin.install "dcos"
  end

  test do
    assert_match "dcoscli.version=", shell_output("#{bin}/dcos --version")
    assert_match "dcos \[options\] \[\<command\>\] \[\<args\>...\]", shell_output("#{bin}/dcos --help")
  end
end
