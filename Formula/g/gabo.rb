class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2aba8f85f9d241217a56847c372f7d7a001218073f76f8e791bc161edd525611"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    system "#{bin}/#{name}", "--help"
    system "#{bin}/#{name}", "--version"
  end
end
