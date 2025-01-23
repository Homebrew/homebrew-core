class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.68.7.tar.gz"
  sha256 "55cd181f2092e1f50779e61650e7b04c0c22bc2d500ae7d9e750b31151bc5643"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3142df2b2c8231f2259aa745e2749fc25739142a2b796b8c7044919d67a64a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3142df2b2c8231f2259aa745e2749fc25739142a2b796b8c7044919d67a64a60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3142df2b2c8231f2259aa745e2749fc25739142a2b796b8c7044919d67a64a60"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1189d2d2acc10608c9ad77375f92072dd921342ef8ea38404cc6dc29427c36"
    sha256 cellar: :any_skip_relocation, ventura:       "3a1189d2d2acc10608c9ad77375f92072dd921342ef8ea38404cc6dc29427c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0120382a359a9ca6694a1200f62423bc9bfa0ea580aca91899874fcb76240e4f"
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
