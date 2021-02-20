class Dlite < Formula
  desc "Provides a way to use docker on macOS without docker-machine"
  homepage "https://github.com/nlf/dlite"
  url "https://github.com/nlf/dlite/archive/1.1.5.tar.gz"
  sha256 "cfbd99ef79f9657c2927cf5365ab707999a7b51eae759452354aff1a0200de3f"
  license "MIT"
  head "https://github.com/nlf/dlite.git"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "03fc30a6130e255cefda07f80ca76331b02dd244510d1dfaca00bec9f2c8c933"
    sha256 cellar: :any_skip_relocation, mojave:      "9bf83b60cbccdb0feab1de1b61221b2b346670591c1e875a7da9fcb05b6ca40c"
    sha256 cellar: :any_skip_relocation, high_sierra: "89cb01faf3eeae034ac8307105b42a23474467179960f95cc6c59c09e23df026"
    sha256 cellar: :any_skip_relocation, sierra:      "8d7de9236c90172bc846a4a9c5ff1fbe0286c1616572c52e3bab2043476603a6"
    sha256 cellar: :any_skip_relocation, el_capitan:  "cab7bd9704df6b1f162a7d258ba3807a9d00cef93395b9fe4b4837a635969692"
    sha256 cellar: :any_skip_relocation, yosemite:    "d1244ccccc75ab8747a86c01aceeb25fee219617d9d4a2c3a3c6cd0bad45c0ee"
  end

  disable! date: "2020-12-17", because: :unmaintained

  depends_on "go" => :build

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
