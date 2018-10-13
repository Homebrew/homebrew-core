class Op < Formula
  desc "1Password CLI"
  homepage "https://app-updates.agilebits.com/product_history/CLI"
  url "https://cache.agilebits.com/dist/1P/op/pkg/v0.5.4/op_darwin_amd64_v0.5.4.zip"
  sha256 "93c8bae059e784fc2409c07e09b53648bd449feca3af1bfec4260e9ae9648830"

  def install
    bin.install "op"
  end

  test do
    system bin/"op", "--version"
  end
end
