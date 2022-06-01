class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/nunomaduro/ohdear-cli"
  url "https://github.com/nunomaduro/ohdear-cli/releases/download/v3.0.0/ohdear-cli.phar"
  sha256 "257e792bf575277e82313350b06100f915711c939b2dc83f88099004397ff7f9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "php"

  def install
    bin.install "ohdear-cli.phar" => "ohdear-cli"
  end

  test do
    system "#{bin}/ohdear-cli", "--version"
  end
end
