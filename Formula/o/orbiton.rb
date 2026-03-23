class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.73.0.tar.gz"
  sha256 "238b58634578fb2f712c255d1493f9658ecf3a1667399825b26aff701cfd9869"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4319349c86486ca5ac9c47fe2ecdd1ca4a3f7ddcaa31dbefb57375aa16ff14c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4319349c86486ca5ac9c47fe2ecdd1ca4a3f7ddcaa31dbefb57375aa16ff14c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4319349c86486ca5ac9c47fe2ecdd1ca4a3f7ddcaa31dbefb57375aa16ff14c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d80c6aebc974e7112d2761ec1affa772e4b54bf54ad23776fe0794901ee3e284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b3fb1185bc51861835a2be4e752ecd629dfda3f83c5bca33eff16a4448a4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3966b77b23d5877d0c4b6ccdfb43cb61f33261a8f9915dfa035792c5ec4a6f75"
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
