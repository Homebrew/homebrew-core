class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.70.4.tar.gz"
  sha256 "0ea08e9555f980b799d0ee9a89b4940bfcf744a0d38def7cd785a3de92381709"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0aa53199b467133033fdc5bae926e591fa439f9c1065b89dd0b688b93a178ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0aa53199b467133033fdc5bae926e591fa439f9c1065b89dd0b688b93a178ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0aa53199b467133033fdc5bae926e591fa439f9c1065b89dd0b688b93a178ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f5788dc7f8455e0d1eedae0b8f749c80323a2a1c08853028472a964880e8bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d9e95dfc1085b8cd8f7a73b1585c677412381d90cfba48205f4518f88cb7540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13796a1413ebd74d83735e72bca4c164e2ed3f84402cbffd9f272e2bdd37e0b"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
