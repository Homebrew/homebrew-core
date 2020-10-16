class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.61.0.tar.gz"
  sha256 "bfb6430e67d8d7e24b4457ea294ff47fdd92e7027a7b0483678513c1e6316164"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5914b77a3d0c387acfbda65e6b8edc4c2b8b07ca1d82c93b88c2c8c24dbec355" => :catalina
    sha256 "bfd0c9d5d94db50b492a3c7283b1e9a4f0d8050d0cebf51af5428ebe57dabd57" => :mojave
    sha256 "7e757757df200ffa8e3224f3f1c7b299873e9c5ce999f7f81fe0ff47913fc4e7" => :high_sierra
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
