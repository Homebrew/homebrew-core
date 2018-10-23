require "rbconfig"
class Lockgit < Formula
  desc "Easily store encrypted secrets in a git repo from the command-line"
  homepage "https://github.com/jswidler/lockgit"
  url "https://github.com/jswidler/lockgit/archive/v0.5.0.tar.gz"
  sha256 "5bfc50eebf7d846c1c227ffb9c92cd45e0f6c15b33316997104b5cc700ea4dfa"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"tmp/github.com/jswidler/lockgit").install buildpath.children
    mv "tmp", "src"
    cd "src/github.com/jswidler/lockgit" do
      system "make", "deps"
      system "make", "build"
      bin.install "build/lockgit"
    end
  end

  test do
    system "#{bin}/lockgit"
  end
end
