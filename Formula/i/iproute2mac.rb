class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.7.7/iproute2mac-1.7.7.tar.gz"
  sha256 "dcbad9b9d6d26e9683c0bbad5a21477558e4df4df8810ddba79005fdca84a67e"
  license "MIT"

  bottle do
    manifest_sha256 "ba99b6411be449f1fd6618083d41c2e2147f1fb4324dae4f933949dc05724842"
    sha256 cellar: :any_skip_relocation, all: "0725ab2a73a1de64f38b5befe4c57a9f512c10a2e0ad6402717f5191d6df0572"
  end

  depends_on :macos
  depends_on "python@3.15"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    libexec.install "src/ss.py" => "ss"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py", libexec/"ss"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge"), (libexec/"ss")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
    system bin/"ss"
  end
end
