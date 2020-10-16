class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.61.0.tar.gz"
  sha256 "bfb6430e67d8d7e24b4457ea294ff47fdd92e7027a7b0483678513c1e6316164"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d403a065edc8dce6ccd9d92070c61a585f8f37cff48835351a420d0278692e20" => :catalina
    sha256 "5a9e24616d893cde56634623ac21c0c2d0d4294d7892bf28cc245a52c3da9be7" => :mojave
    sha256 "0223f0fa136df70e9c403d82fcde1ebd5c5284b0c977ef18e9ef0122477943ea" => :high_sierra
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match /200 OK/m, shell_output(cmd)
  end
end
