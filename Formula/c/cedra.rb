class CedraCLI < Formula
  desc "CLI tool for Cedra Labs"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "sha256:7ba7fc9857ebb2da994bbf21300018553e3b7593d0b7608058ca9e3fdc82b835"
  license "MIT"

  depends_on "rust" => :build

def install
  system "cargo", "install", *std_cargo_args
end

test do
   assert_match "cedra", shell_output("#{bin}/cedra --help")
  end
end
