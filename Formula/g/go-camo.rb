class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "e75d744025c97121566209e63dce13edd41ed0d396db9fc2ca0ddf6d862c1293"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4bd957290e0698f9d2c72a04a75791fffd3d66fdf8e300723d9473733e0dd5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a550b8c68231ad958546030b8fb86cb464cb3fdf0079decb1e1cff1aa8412e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4279deb00ac9e4bc3192bdda33e9d935fe8d00cd47c55dc840d7272636067ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69d0fc0c3c114967483e86b047421d84b944c1e5a91b8c8f2c719e3afc8a8493"
    sha256 cellar: :any,                 x86_64_linux:      "407c6ade3e90117c743f1cdee87d7721d94cbfcbdf83331e774c7bf67350da69"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.ServerVersion=#{version}"
    tags = "netgo,production"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/go-camo"
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"url-tool"), "./cmd/url-tool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-camo --version")
    assert_match version.to_s, shell_output("#{bin}/url-tool --version")

    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
