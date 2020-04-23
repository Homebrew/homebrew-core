class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.5.tar.gz"
  sha256 "7e0a935966ab5b434f4c60335808be167e4b300d8cb0b0feb987adb7fc562521"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ff43752d28cd7354894416c046d6ddc19fe1744917bb44eed440284660fe107" => :catalina
    sha256 "4b84327598eb445a5b915b9f825ddcda5fcb520b9bfb6cf2a456f2ec9ab44af4" => :mojave
    sha256 "33111c937be1bda0baa751f4aa0dda25b4b266efe93f999a48498442b50edda1" => :high_sierra
  end

  depends_on :macos # Due to Python 2
  depends_on "mercurial"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
