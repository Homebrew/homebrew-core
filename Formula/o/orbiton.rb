class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.7.tar.gz"
  sha256 "af4cd80f52cbf5af2845b9b61e6f35c81994dcd99275e955210bf2495393b1cd"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8d3d8cb7aa2b8a4e22b02f46ef759a00c9eb2d28ea9751072b3c04c870f58f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ab136d666407054324749ce41b4cfd1c13cb8b9de540538f87202d08c21baeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d09527029fb6b362126d53ccb96323a391ad4ac5988223794dbe6572b526939"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ae7ea8aff8097a2272aec5e71f43d3799fdf875b20792473caaa9e7caaf9cd2"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9dab85889accc4772171f5379f619bb3927b89e5dc9d19a3ee043e242c9181"
    sha256 cellar: :any_skip_relocation, monterey:       "f210a05a58c17acbb29f78def4cab5887cdd3a751644a2b693036fc046a2a67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91eb49c10d1c9eb8d6aa81823e74e91d9c9a69bd52f177183910a81f1814fa9"
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
