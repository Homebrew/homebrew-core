class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v.1.4.2/iproute2mac-v.1.4.2.tar.gz"
  sha256 "20e2265e6c39eacde2e581a2b979de105225ff58c735626c7170be1064c3ed3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe22f10cb5fd9b37009ee95ad78c6122952d43f33ea919247fc47f7f3f3530de"
  end

  depends_on :macos
  depends_on "python@3.12"

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
