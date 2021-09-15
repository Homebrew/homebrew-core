class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.3.0/iproute2mac-1.3.0.tar.gz"
  sha256 "3fefce6b0f5e166355fdb04934cbdd906211b64e5adb6a385469696dc51233b7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0730da7b695c8ae7a5f08a7c7e49f795e80a444146b21bf80076f7ef7712365"
  end

  depends_on "python@3.9"

  def install
    bin.install "src/ip.py" => "ip"
    rewrite_shebang detected_python_shebang, bin/"ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
