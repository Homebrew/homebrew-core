class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.6.2",
      revision: "dd9c19c37a878cf4a81b18efb8d6f0599c7da923"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0104caeb286c38a7a9f920f9c93e21ec542274fe35fb1618f921fcd52fde4b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c83911684793c99ce8192304aa6f60ea9741a398bf9e9e51d5623b5ce556797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ef2a38eed42d7a5cc6ec6bda937b8e0edc12dbb313a587d7da92f3b0a7018a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d56fe3db5327332c44833c7ad657bd26a79f5d1ea96e0bcae283e5261a33aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb438ff14b3e20ce2d3dfc66f810f76af0f437a762e8398749dbb24f0761c552"
    sha256 cellar: :any,                 x86_64_linux:  "888e53f7fa454054b602a0872cbb8993d5398f71aa9b49b7b5cd8a6c997317ad"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    ldflags = %W[
      -X github.com/openbao/openbao/version.fullVersion=#{version}
      -X github.com/openbao/openbao/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/version.BuildDate=#{time.iso8601}
    ]
    tags = %w[testonly ui]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"bao")
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"

    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end
