class AzurePimCli < Formula
  desc "Unofficial CLI for Azure Privileged Identity Management (PIM) roles"
  homepage "https://github.com/demoray/azure-pim-cli"
  url "https://github.com/demoray/azure-pim-cli/archive/refs/tags/0.6.1.tar.gz"
  sha256 "04f8157a5645d2c6e388b4bd151effda7545779c79dc537a2dd8dcba4d14379f"
  license "MIT"
  head "https://github.com/demoray/azure-pim-cli", branch: "main"

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
