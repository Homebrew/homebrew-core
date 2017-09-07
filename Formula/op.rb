class Op < Formula
  desc "1Password CLI"
  homepage "https://1password.com/"
  url "https://cache.agilebits.com/dist/1P/op/pkg/v0.1/op_darwin_amd64_v0.1.zip"
  sha256 "fccec086ef70d9fab464c8e5cb4b1748236cb7633c9aae52512fd6502686ad09"

  def install
    bin.install "op"
  end

  test do
    system "#{bin}/op", "update"
  end
end
