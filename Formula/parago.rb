class Parago < Formula
  desc "A command line tool to help you rapidly create machine learning models"
	homepage "https://github.com/skafos/parago-cli"
	url "https://github.com/skafos/parago-cli/releases/download/1.0.0/pgo-v1.0.0.tar.gz"
  sha256 "168ef6b7c655c746feb686344abbc3fd5f1657efdcebba9db82cc70499a2b33c"
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
