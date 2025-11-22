class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.2.0.tar.gz"
  sha256 "56289b8dd36a43e7ccc235d2a2c0b3bc53137b0803bd1daa42299a44210645cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "076899e855f4137de04f4f32e18a2179c4ab1b46ff0bd4075eabcc2ae903bd1e"
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
