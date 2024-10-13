class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://roboticoverlords.org/orbiton/"
  url "https://github.com/xyproto/orbiton/archive/refs/tags/v2.67.1.tar.gz"
  sha256 "f5bef0bae5dedf43794d83782c3f3264860a113f7caa2db0abc554132e041fc4"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3e5682bf86e752aec5457a2303536e6abe9d1df001761cd34fc1f3619d2d3a78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e5682bf86e752aec5457a2303536e6abe9d1df001761cd34fc1f3619d2d3a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5682bf86e752aec5457a2303536e6abe9d1df001761cd34fc1f3619d2d3a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5682bf86e752aec5457a2303536e6abe9d1df001761cd34fc1f3619d2d3a78"
    sha256 cellar: :any_skip_relocation, sonoma:         "02d926296a717bd71287f62b7ed702aef96f93784d7c4a9300576c00bdc4e1b0"
    sha256 cellar: :any_skip_relocation, ventura:        "02d926296a717bd71287f62b7ed702aef96f93784d7c4a9300576c00bdc4e1b0"
    sha256 cellar: :any_skip_relocation, monterey:       "02d926296a717bd71287f62b7ed702aef96f93784d7c4a9300576c00bdc4e1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead304496d1390901b4b20c3d2b0edcff67fff86b2e9dfde0ac4fe61891be4d4"
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
