class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.2.1.tar.gz"
  sha256 "282e976178e07f941cd627db9a5760508dcef43fc0dbd51613cb37f5003b321d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "229749a7462fb0963cb584dac715a6faf6fe03be20266ea5c8fa973c0f2fce86"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS

    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
