class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.5.0/download"
  sha256 "f4f486482861a200386f0799a53d02474d84e1b236e3e0bb1ea920813d1a6354"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e8bfd54d28b68614593a22b25f831ee6b197ad9d352ce548b06ae83e9b5846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "692ba4461db653075f94bde6502977344b53d8d2652850fdcf5ff274379ab281"
    sha256 cellar: :any_skip_relocation, monterey:       "427941fd653d8d87276e86355e3c55ccfca08954030ac4cd1577a4fef8ae72a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9504fbb1d806c83fe023d101747075c3e8cbbb3d973674a88165fc4090b30849"
    sha256 cellar: :any_skip_relocation, catalina:       "d27bdc6f9db62e42c2294da6c177559010489d64b2fb20445021abecf881b128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ba3c00db004a2f90c73fca85cec173f25e974f6fb885fdd87616dbc6d9bd47"
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
