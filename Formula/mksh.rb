class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59b.tgz"
  mirror "https://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R59b.tgz"
  version "59b"
  sha256 "907ed1a9586e7f18bdefdd4a763aaa8397b755e15034aa54f4d753bfb272e0e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f558d90c4feae917f31026ba75dd757d5dca170c819320a2a3595bec487a17a" => :catalina
    sha256 "e957fc3249181ba27dc58a60835a7e08ac8de137c9e7addc7e5ffd845214083c" => :mojave
    sha256 "09b3570614ce07378456c65ce5a9698cd92fbd794cfceab8b056f3d22bc9d577" => :high_sierra
  end

  def install
    system "sh", "./Build.sh", "-r"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
