class Parago < Formula
  desc "A command line tool to help you rapidly create machine learning models"
	homepage "https://github.com/skafos/parago-cli"
	url "https://github.com/skafos/parago-cli/releases/download/1.0.0/pgo-v1.0.0.tar.gz"
  sha256 "0c404cff981a6798e2e1bf866c41efdf36e91d2f8fd6c939293b04657691338f"
  depends_on "node@12"

  def install
    inreplace "bin/pgo", /^CLIENT_HOME=/, "export pgo_OCLIF_CLIENT_HOME=#{lib/"client"}\nCLIENT_HOME="
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pgo"
    bin.install_symlink libexec/"bin/parago"

  end

  test do
    system bin/"pgo", "version"
    system bin/"parago", "version"
  end
end
