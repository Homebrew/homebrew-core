class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      tag:      "v3.0.1",
      revision: "9ef3642d170d71fd79093c0aa0c23b6f2a4c1c64"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d6616ba0e64ee406559414e2c6325f46b0ddc16fc20dde42cad3e3fc7d3df223" => :catalina
    sha256 "068251847cb8be7e495f093d86468eec1d6459f9a4daa0ba6b7936b49cc14735" => :mojave
    sha256 "98d0266e847077f64dbff9bac8db93e0d3044425efc4992374be23ddb94d7d3d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"gobuster"
    prefix.install_metafiles
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end
