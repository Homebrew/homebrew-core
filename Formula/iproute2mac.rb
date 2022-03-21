class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.4.0/iproute2mac-1.4.0.tar.gz"
  sha256 "23e9c3014687bce1cb3b17a7a22297ad582175025a9fe96fe894401f329da808"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ae5a1243448e699b5e82c093c9dfcdcdc13b84b586f7d77bc1959c6942ad21c"
  end

  depends_on :macos
  depends_on "python@3.10"

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
