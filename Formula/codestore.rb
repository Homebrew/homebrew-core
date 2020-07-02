class Codestore < Formula
  desc "Command-line interface of code.store"
  homepage "https://code.store/"
  url "https://s3.eu-central-1.amazonaws.com/s3.code.store/codestore-v1.2.12/codestore-v1.2.12.tar.gz"
  sha256 "7474ac084e12cdd946b30e2eed7e5689cfbc656ff19e53f947141e67fa3c0d28"
  license "MIT"
  depends_on "node"

  def install
    inreplace "bin/codestore", /^CLIENT_HOME=/, "export CODESTORE_OCLIF_CLIENT_HOME=#{lib/"client"}\nCLIENT_HOME="
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/codestore"
  end

  test do
    system bin/"codestore", "version"
  end
end
