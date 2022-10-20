class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.5.0/download"
  sha256 "f4f486482861a200386f0799a53d02474d84e1b236e3e0bb1ea920813d1a6354"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9390af37f562fcd54045ba9f4d95e561f407acadf19a5abc685919452c0c91fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddb29be78295c3492cdbc1b7798618c73fb42aa8accb3fad0b29b108c46ca489"
    sha256 cellar: :any_skip_relocation, monterey:       "dd16ac202900fcda148f1ae629908064b91e31fab8de494c088e1ee144c8cb89"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d8b12cdcb670a5bba1dffc8f1c5d14599b033b85ec9547e054cfdb0ed65eda"
    sha256 cellar: :any_skip_relocation, catalina:       "e0b392b5e11f66ddda73d202c48793985015da3e519b52337c6f0b9d945fc1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4595f986e4003550d3d05c7bca46dd33b563bfcf0c3a5fc969c2787f17a56156"
  end

  depends_on "rust" => :build

  def install
    system "tar", "xvf", "pipe-rename-#{version}.crate", "--strip-components=1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write "#!/bin/sh\necho \"$(cat \"$1\").txt\" > \"$1\""
    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system "#{bin}/renamer", "-y", "test.log"
    assert_predicate testpath/"test.log.txt", :exist?
  end
end
