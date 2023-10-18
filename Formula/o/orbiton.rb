class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.2.tar.gz"
  sha256 "9f16e7f651df13b0fac0508e634f1620ffd77fe86ae1da506dfc902827eac4df"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c73d98812c5237a6108984e9e2444a7901e3a07e619f2974fde7bbfaa211c99e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88c336d7b70c4dfec3882faa13259a52abbd057a00f775692259b07b940516fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2658eb0d344cde0d633e90c9f4ddb49bbedd1aebef194f3ea936140a1c0d16"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fed9123e382559a148ee0ccd5a4cbd42c7d0c42afb5f829e1b82b59965287dc"
    sha256 cellar: :any_skip_relocation, ventura:        "1125fd4a866ca0be6fd4d655c1bcddae39912911dd3086d3d6bcf4f63ceaf6fe"
    sha256 cellar: :any_skip_relocation, monterey:       "23e7bf452f22428eeb70f8b34143d52dc02d76b6db919d2490fbbd7814f1a2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec84422df5162e14e1ec8ca335fbbe0037e072f42b1a24458446f446a21407f"
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
