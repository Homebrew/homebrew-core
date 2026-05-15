class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.74.0.tar.gz"
  sha256 "3340f40517cd4d7c1e67b6e0ca8c777ed2e2387cd573f604c88ec96531cbba67"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027ca0e01c7941401647c03e689d43f423eaa2d72ff5e81a96e92ece8a4b4626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027ca0e01c7941401647c03e689d43f423eaa2d72ff5e81a96e92ece8a4b4626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027ca0e01c7941401647c03e689d43f423eaa2d72ff5e81a96e92ece8a4b4626"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d3a5edd15d026a8ee14ec585d826d9faabc50352065212a3dd77daa7871c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e1c363e37bb80da4cf290848b962832f928fa2736350170cb07159793c2de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b90c25875f9147c94715d5214b7d33ec1decf71e2734df5f034644d067c9fb"
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
