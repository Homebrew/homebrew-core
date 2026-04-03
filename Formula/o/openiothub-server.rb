class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.24",
      revision: "2fbedda79499dc3f6e8f0a7c7d28d807861f43e4"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957599fbb85a7e43718fc0aa9ed313dbb921bb7cb168ed9a3de612be7584f1bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957599fbb85a7e43718fc0aa9ed313dbb921bb7cb168ed9a3de612be7584f1bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957599fbb85a7e43718fc0aa9ed313dbb921bb7cb168ed9a3de612be7584f1bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9cf3f5bf29238c1d157e31060d12fd3fb9e97cf5b56dc238f5495634f2da76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97109c1db206f3acd77630ece94eae406fbb738b1805809d1c07e5698dc15e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b57ad6513b5232ccec1d9598aa292e70f20ec50b7dd311197f9ae03436c383"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_path_exists testpath/"server.yml"
  end
end
