class Grapa < Formula
  desc "Modern programming language with unlimited precision arithmetic"
  homepage "https://grapa.dev"
  url "https://github.com/grapa-dev/grapa/releases/download/v0.1.51/grapa-mac-arm64"
  version "0.1.51"
  sha256 "b3b6fad6bfc2e2d73cd877614c69661d782ed00be3b24f99bca5ae9450a993f1"

  def install
    bin.install "grapa-mac-arm64" => "grapa"
    chmod 0755, bin/"grapa"
  end

  test do
    assert_match "Version:", shell_output("#{bin}/grapa --version")
  end
end
