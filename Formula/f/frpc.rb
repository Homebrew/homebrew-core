class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "1dd367d6d822a7fce1d3012fce0a6e778bc90c454e2c7baa0eb1e6de6054c61b"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66d2ce8f4127355b95f3d373ef2b01fcd76a43cb61ed3c181e220d34440b08e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d2ce8f4127355b95f3d373ef2b01fcd76a43cb61ed3c181e220d34440b08e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d2ce8f4127355b95f3d373ef2b01fcd76a43cb61ed3c181e220d34440b08e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9deaa949b155ea66b0e7067f73d8df19e55a8ec73158bbcd06613f2dd7196f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17313ae519e7783f3c589f275b93f3b129637e582d0e6cf3552c253dd86054db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b13757fc1a888d1199b3b741a44010752de0cd10f1dd05c5a4fb27bd21cbec"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build-only"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
