class AzurePimCli < Formula
  desc "Unofficial CLI for Azure Privileged Identity Management (PIM) roles"
  homepage "https://github.com/demoray/azure-pim-cli"
  url "https://github.com/demoray/azure-pim-cli/archive/refs/tags/0.7.0.tar.gz"
  sha256 "730edd638d161f0e81b2e0ce3f479e4ac21a3bb125457b02af60966ac7a607a3"
  license "MIT"
  head "https://github.com/demoray/azure-pim-cli.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "azure-cli"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/az-pim --version")
  end
end
