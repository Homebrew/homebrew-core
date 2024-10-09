class Fortify < Formula
  desc "Command-line tool designed to enhance file security through encryption"
  homepage "https://github.com/i3ash/fortify"
  url "https://github.com/i3ash/fortify/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "6c26b867bc61d53f24d13934298b4d32e1b470750b6379f617f2153d67462793"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/i3ash/fortify").install buildpath.children
    cd "src/github.com/i3ash/fortify" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "."
    end
  end

  test do
    system bin/"fortify"
  end
end
