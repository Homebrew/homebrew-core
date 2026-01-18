class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "afe1aca9f6e7680a95652e8acf84aef4a74bcefe558b5b91270876066fff3019"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed0351eb4f1fab57f4551bfdb26741585a71c632166ea148d610bd2e4fd9be0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0351eb4f1fab57f4551bfdb26741585a71c632166ea148d610bd2e4fd9be0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0351eb4f1fab57f4551bfdb26741585a71c632166ea148d610bd2e4fd9be0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a8c15839d1cc397750195d1947279be5ea5ddb6725f0f0af8e810f499e5d50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f948c98e8df7d97104426b4a4e989ed71e645c83f3b495e1f3eeaa1b0ceb3f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb425a9c9bc53cc68ac1c4986f17d8c2863fcf394e2d1adeaf2ec183e27d67a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
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
