class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.6.tar.gz"
  sha256 "81edd70f806ac4e2b5a3cc0c2ce3493de4b54395c6e741e45b4efbccb295b71a"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5bab641261f28e9fca0b464271ad70f72a3ec6f7fe0b52e37b0c752664c6181"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9201bf242753aad3e3079ba521736da298f6ee07fd606aa9444ed6019550b3ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56eca7ac0c1e597dbe48cba793e2e8511b4ee1f4975eaa2dbb4dc7805fa00d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a47f0fd499638f9df31f04118713c7907e77da5f96b6218042f404661a158bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a5439264d7fb6e5f2283bfbb226ae766d009e69c8466d26de972f052a286708"
    sha256 cellar: :any,                 x86_64_linux:      "c7c2cc3acf8a187a737ad77b8e088a4c3099c097c1048749579900af6ba23809"
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
