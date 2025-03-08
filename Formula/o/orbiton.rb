class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.68.9.tar.gz"
  sha256 "acce203a95f1fbbcfdc75abdf88cbe6473e5ff97f99757263d7e195eb4f8640d"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a252464791b7a28044b241182cf141fb9a8da1b59bd26fb5de52e63ffefeeba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a252464791b7a28044b241182cf141fb9a8da1b59bd26fb5de52e63ffefeeba7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a252464791b7a28044b241182cf141fb9a8da1b59bd26fb5de52e63ffefeeba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f0b3f6f71e6a731d495b079912cb7d8de4ea3c8b26b6004b8a27072a2ad5502"
    sha256 cellar: :any_skip_relocation, ventura:       "4f0b3f6f71e6a731d495b079912cb7d8de4ea3c8b26b6004b8a27072a2ad5502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40cfac5d9a67426cdf7d6ee313c48c1e77ac773fa4491cf1510fdcd1ef65bd8e"
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
