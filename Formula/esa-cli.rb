class EsaCli < Formula
  desc "CLI tool for managing esa.io articles"
  homepage "https://github.com/shellme/esa-cli"
  version "0.1.1"
  url "https://github.com/shellme/esa-cli/releases/download/v#{version}/esa-cli-darwin-universal.tar.gz"
  sha256 "2e282a3cb0c9dc74efaea1a5767f89d8a4e3f9fafaa0285713b54c1df9f2a68e"

  def install
    bin.install "esa-cli"
  end

  test do
    system "#{bin}/esa-cli", "version"
  end
end 