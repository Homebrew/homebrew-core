class Hop < Formula
  desc "Interact with Hop in your terminal"
  homepage "https://github.com/hopinc/hop_cli"
  url "https://github.com/hopinc/hop_cli/archive/v0.1.19.tar.gz"
  sha256 "520e7b63e7714b20bd342ae723b8a322aa44dc0f0dee0264974c83977e25fcca"
  license "MPL-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/hop", "-V"
  end
end
