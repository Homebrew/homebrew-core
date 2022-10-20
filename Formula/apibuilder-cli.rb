class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.43.tar.gz"
  sha256 "69c8c100ba9d56e83c146b5338c2a68c189fc6d1ca2eb184f357a84091224077"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "928a2a30b122f17f8d1c297b5440c8a7b58755aa3da21e0f98f34600171486c4"
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
