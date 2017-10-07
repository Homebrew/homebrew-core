require "language/go"

class GitAppraise < Formula
  desc "Distributed code review system for Git repos"
  homepage "https://github.com/google/git-appraise"
  url "https://github.com/google/git-appraise/archive/v0.6.tar.gz"
  sha256 "5c674ee7f022cbc36c5889053382dde80b8e80f76f6fac0ba0445ed5313a36f1"
  head "https://github.com/google/git-appraise.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/google").mkpath
    ln_s buildpath, buildpath/"src/github.com/google/git-appraise"

    system "go", "build", "-o", bin/"git-appraise", "github.com/google/git-appraise/git-appraise"
  end

  test do
    system bin/"git-appraise", "help"
  end
end
