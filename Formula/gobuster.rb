class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      tag:      "v3.1.0",
      revision: "f5051ed456dc158649bb8bf407889ab0978bf1ba"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8f36299b36b59006637dcc7d062614eb209ba82a31f5a67fce789c4d6ef9562" => :catalina
    sha256 "16912d38db06501d02cdab6066d1da01129779d958ce142c40018cce30328fc4" => :mojave
    sha256 "341ce02f5e99ba1bf9cee8d6cbdd150a6e36d8b0fd811ded7a2da8933d877f9a" => :high_sierra
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
