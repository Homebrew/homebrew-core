class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.6.tar.gz"
  sha256 "7f4cd714b9551e7a13a006f0fb73cbda6448abd13c9597d8f91ad1ab3ae607f6"
  license "MIT"
  revision 1
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c473246a77bec35a66a8a707873f1bc8649da9df73aa5d5fcae650403de7e921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0891a2a485b0cab7fd7ce8a888f40f03988ac69ab96ea1524975ca1d5f722403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "978ee728779ea0bb5f26ca997acf0983bb282d4151d793370f4b4e893a4d5cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "97ca54f1aaaeb7e1433e4dfc5bc10e1fde65d6689b4daba91e77474f2940be01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45d3ee6ac754a0c4b3150f3040c0bf5497e410e0339bb7948b65b60633a8333d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec3f113b225c212860f40fb65b0e97f03128c39a6107cc938debb301dc7d7c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write <<~SHELL
      #!/bin/sh
      echo "$(cat "$1").txt" > "$1"
    SHELL

    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system bin/"renamer", "-y", "test.log"
    assert_path_exists testpath/"test.log.txt"
  end
end
