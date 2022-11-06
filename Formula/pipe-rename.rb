class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.6.0/download"
  sha256 "3e937ce8c7ef53758ffa41fec519ac773f929d422c7674a09f1aad6340ca5ea6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce60f3e62a28dbbbb19113b034164b78d02cce187a51a648be8f7d6520e4ac3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b754ffa3266ebab2ac8102b52903848c9a42f3e9ce9b771ef18c425917532abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b109fd2995423dd435d78b01597bdc61616171e53747a5e3cf06c5494d890d"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc3a4c5f98ef69e776fff5e0968c74cb4fe65392f91f2d8130ebb2b945025c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02dd9a819d213f504954434341ac1d312325f8006260de241c1135255d49743"
    sha256 cellar: :any_skip_relocation, catalina:       "a9621c89f905d6bbff78e932647a62b6f3f932572500cab3b3fcd174e6c86a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f5b57d5038a9fe16abc29e6bdd3dce922d90d393fe9385337079a8c1c35af6"
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
