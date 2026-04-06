# frozen_string_literal: true

class Devlog < Formula
  desc "AI-powered development log generator for git repositories"
  homepage "https://gitlab.com/aice/devlog"
  url "https://gitlab.com/aice/devlog/-/archive/v1.1.0/devlog-v1.1.0.tar.gz"
  sha256 "fd8979babdcc7624c94e7baeba52448846343cf659751d4546bd802147e572ca"
  license "MIT"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal version.to_s, `#{bin}/devlog --version`.chomp.split.last
  end
end
