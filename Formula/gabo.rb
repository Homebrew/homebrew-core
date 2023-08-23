class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "3a0ad4eaa28ba7c5801ffa0e5a3b2fade09ef597281c2d58451792a75b26df52"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "build_prod"
    bin.install "src/gabo/bin/gabo" => "gabo"
  end

  test do
    system "#{bin}/#{name}", "--help"
    system "#{bin}/#{name}", "--version"
  end
end
