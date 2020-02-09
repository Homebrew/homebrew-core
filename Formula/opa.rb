class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.17.1.tar.gz"
  sha256 "e17901b92d37e031f46b9f68180e7beed696b67de108a7192c902925607a978d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b3e35f7a544f449aa7b7a704626949abe9f5605ddbeebda26c4c0a2217e375c" => :catalina
    sha256 "f3707bf85f0ce9e7f8974c6a3c380d532884890471715c309ac10c37f1070b7a" => :mojave
    sha256 "e96be38698a07893f95924353b66e7f17bc928accd6b145963d80a15f1ffc557" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
