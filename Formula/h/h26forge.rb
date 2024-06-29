class H26forge < Formula
  desc "Tool for making syntactically valid but semantically spec-noncompliant videos"
  homepage "https://github.com/h26forge/h26forge"
  url "https://github.com/h26forge/h26forge/archive/refs/tags/latest-8dde7ec.tar.gz"
  sha256 "c4dd98a640cace84ae4dd5df31ac0367e0ee3c95c940883a329006b23b7ad273"
  license "MIT"

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"h26forge", "generate", "-o", "out.h264"
  end
end
