class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/nunomaduro/ohdear-cli"
  url "https://github.com/nunomaduro/ohdear-cli/releases/download/v3.1.0/ohdear-cli.phar"
  sha256 "26c0ef44c467de6cbf8d068fc9f1b55a5375a4cbfd91520ce594defb8fe8b7c6"
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
    assert_match "Unauthorised", shell_output("#{bin}/ohdear-cli me", 1)
  end
end
