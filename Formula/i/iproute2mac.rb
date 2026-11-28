class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.7.7/iproute2mac-1.7.7.tar.gz"
  sha256 "dcbad9b9d6d26e9683c0bbad5a21477558e4df4df8810ddba79005fdca84a67e"
  license "MIT"

  bottle do
    rebuild 1
    manifest_sha256 "755ab79b1eb524c6e9265a13a620d5397154d10d15c38776c8321e3ce08abc42"
    sha256 cellar: :any_skip_relocation, all: "dc08505a778949bea7abc673bcb928910ada16494911e2ab142daef517a35c28"
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
