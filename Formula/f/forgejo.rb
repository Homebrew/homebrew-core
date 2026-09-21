class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.5/forgejo-src-16.0.5.tar.gz"
  sha256 "5d1199d7b58c977f025acd4f078d5ae535e537693ce600fd271652b84e3dca86"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17d615f556df87b83eaeccc6f2f43f08960a56ed214f7a3bdeb6872ede3c0886"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ebb3812819299f7f19ac965ff9e430451a3f0633a2a2bec7052001e1b2db89a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "face8288dfd8234fb3a96d275cb989f93434016441d1bc238387a0360df2e3e7"
    sha256 cellar: :any,                 arm64_linux:       "1ea767d3d537db6340deb779122a5979d0d567e197a3c5656fffdf36de2035ac"
    sha256 cellar: :any,                 x86_64_linux:      "1cbecf3cf617c67fb09dcb54b944ed19de67d707bd73ca8a88a4809149657572"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"

    generate_completions_from_executable(bin/"forgejo", "completion")
    # powershell completion uses "pwsh" as the shell name
    # instead of the usual "powershell" used by generate_completions_from_executable
    (pwsh_completion/"forgejo").write Utils.safe_popen_read({ "SHELL" => "pwsh" }, bin/"forgejo",
                                                            "completion", "pwsh")
  end

  service do
    run [opt_bin/"forgejo", "web", "--work-path", var/"forgejo"]
    keep_alive true
    log_path var/"log/forgejo.log"
    error_log_path var/"log/forgejo.log"
  end

  test do
    ENV["FORGEJO_WORK_DIR"] = testpath
    port = free_port

    pid = spawn bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl --silent http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
