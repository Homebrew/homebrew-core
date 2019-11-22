class Kzenv < Formula
  desc "Kustomize version manager inspired by kzenv"
  homepage "https://github.com/nlamirault/kzenv"
  url "https://github.com/nlamirault/kzenv/archive/v0.2.0.tar.gz"
  sha256 "33d779e6d4eb22ede86709debbda4438f1fa76f0785b5697620640f5d47d7ab2"
  head "https://github.com/nlamirault/kzenv.git"

  bottle :unneeded

  conflicts_with "kustomize", :because => "kustomize symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system bin/"kzenv", "list-remote"
  end
end
