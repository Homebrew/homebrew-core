class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.25",
      revision: "fdb2c316abb5b128cc1862032d3a724ba4378d59"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5757632fdd6d54d98a0ec8d16d6515c79e93c4ad801b79e4730fccf02e386290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5757632fdd6d54d98a0ec8d16d6515c79e93c4ad801b79e4730fccf02e386290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5757632fdd6d54d98a0ec8d16d6515c79e93c4ad801b79e4730fccf02e386290"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3ecd0d5cd2faa7bb3c00af571e89dd06fd31c96eb87b72d2bf431d33e24fc50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb01133397e06f82b40a6ea102b59aa3afca37afb8eb51d70d292a7147f4fc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb63c2b8d87b6aaf9c0f88840fcda0cf9d176754386e191c3ffeedc1a3ef18d"
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
