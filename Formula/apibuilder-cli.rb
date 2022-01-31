class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.42.tar.gz"
  sha256 "bffdf934888dd9ef78a5a0b029fea743732899551cfbbe5d8203222718ffe4f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53513c0623771a5d5fe3de708e2b89f99f930de4502d40612f317e51d0703e55"
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
