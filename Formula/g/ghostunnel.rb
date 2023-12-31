class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "4a573d31001067235a2fc0470316b419d3397418bd8f09a5b8cf9c93c23b7433"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "474880279a3686ee6c3c1fc2f2f0386b02750841e864a95a911868faab35abca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8f1961e2052037da00f2fe782d73d68546e49bdd9b06c529751805197cfd62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d336fe33d290ab7a2b0d678f1ff81299ba3388e5ff839473bc7aa053535b0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f77ce157e19aea9f6e8c19a23692b780e0553a3535bebdf8d5fc26ea1f607af7"
    sha256 cellar: :any_skip_relocation, ventura:        "b5e4581471e20563f6d8eca52bd0906999d59eda01529c363fb30bdb95f8f4cd"
    sha256 cellar: :any_skip_relocation, monterey:       "e5c4f0f685182f28cca485a60bdb39c910915f68c3524c48c6be4f63a7e06470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccebe6328b522bff12b1b4d53ebd84afde3173c30496ce3c5f089ca4bf40e145"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
