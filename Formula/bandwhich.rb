class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.8.0.tar.gz"
  sha256 "87dfe3f749b7e04b62e0bbfcbe98e02df16b92c84a55fb70993d9b31f57efb4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a3fe1479980e18c99ebbbcfc2716c9bc4fc825c79a9f24330f3b82e89d6084c" => :catalina
    sha256 "816d09ae42a5fc7f4556428d70c6a7746f65396b9b087dfd4505ea17bb9204c1" => :mojave
    sha256 "def9fa45ee604e309f3e3e5d35007a1e4f47c46a8090b692cb344176ce449bcd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
