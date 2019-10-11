class Dlite < Formula
  desc "Provides a way to use docker on macOS without docker-machine"
  homepage "https://github.com/nlf/dlite"
  url "https://github.com/nlf/dlite/archive/1.1.5.tar.gz"
  sha256 "cfbd99ef79f9657c2927cf5365ab707999a7b51eae759452354aff1a0200de3f"
  head "https://github.com/nlf/dlite.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03fc30a6130e255cefda07f80ca76331b02dd244510d1dfaca00bec9f2c8c933" => :catalina
    sha256 "9bf83b60cbccdb0feab1de1b61221b2b346670591c1e875a7da9fcb05b6ca40c" => :mojave
    sha256 "89cb01faf3eeae034ac8307105b42a23474467179960f95cc6c59c09e23df026" => :high_sierra
    sha256 "8d7de9236c90172bc846a4a9c5ff1fbe0286c1616572c52e3bab2043476603a6" => :sierra
    sha256 "cab7bd9704df6b1f162a7d258ba3807a9d00cef93395b9fe4b4837a635969692" => :el_capitan
    sha256 "d1244ccccc75ab8747a86c01aceeb25fee219617d9d4a2c3a3c6cd0bad45c0ee" => :yosemite
  end

  depends_on "go" => :build

  # DLite depends on the Hypervisor framework which only works on
  # OS X versions 10.10 (Yosemite) or newer
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/nlf/dlite"
    path.install Dir["*"]

    cd path do
      system "make", "dlite"
      bin.install "dlite"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
      Installing and upgrading dlite with brew does not automatically
      install or upgrade the dlite daemon and virtual machine.
    EOS
  end

  test do
    output = shell_output(bin/"dlite version")
    assert_match version.to_s, output
  end
end
