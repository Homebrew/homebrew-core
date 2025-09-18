class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.5.tar.gz"
  sha256 "bc3cc51e02578e0c56f252e65136dbeb635ffc8468c45b5c38df311cab611b09"
  license "MIT"
  revision 1
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fd3ea356570b8c33201ff8b6e4c226be7dc46b29d648ede51b9e4ad7c51ee94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b5d7a3e3d2800214c3d6c019965abc4c79153e877f9646f0785b731403cd42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ad5f875ea0698f555e7cd1ae0e9cbf3f2288df1a629aea13d73e88d8410868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ead196d4a945b353937da16ba88d97705b9e63359a66a7d1413e84be958728c"
    sha256 cellar: :any_skip_relocation, sonoma:        "55b14b5cc02d4940996223565bffe107205f002b712b1851759121e32352478b"
    sha256 cellar: :any_skip_relocation, ventura:       "e78cf189b9daf7abe12c7067ee35d9716e268abe6210014b85ced4aa201c605d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76acb0c610a7ca3269b0330affdcfdee2f6549c0fd59883b00bca7bcc61f0393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3c6d9051347cca1f0a699b770f0acb148b5f079a75bec57e9f1b690360e935"
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
