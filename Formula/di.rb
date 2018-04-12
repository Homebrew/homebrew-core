class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.46.tar.gz"
  sha256 "3cc77280618d5e7b61eeedd3f25bb8521a6de5420793d73e217ce2c83d8e5333"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6b73f6857b8b029f1b2aaf6bd6318c4ce6ddb6d2acb984136197da2105edf4d" => :high_sierra
    sha256 "5af2e6470606f15bc327aa250238dbfe61d288aa39396e6567f06a495fb9f143" => :sierra
    sha256 "0d0d0ac1a487899b51382a6e462bd0085f0e1181b8a4f3b65fcb04ebf608aa73" => :el_capitan
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
