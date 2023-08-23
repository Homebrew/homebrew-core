class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ddc77523d0a68c54402187482c5281c17cc072391c9f129fc5aa1504f820c8ef"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "test", "./...", "-v"
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    system "#{bin}/#{name}", "--help"
    system "#{bin}/#{name}", "--version"
  end
end
