class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.4.0/iproute2mac-1.4.0.tar.gz"
  sha256 "23e9c3014687bce1cb3b17a7a22297ad582175025a9fe96fe894401f329da808"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ea180af8a15eace187d17e2f95a84e417445e5175646f6f61b9931633ddf264"
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
