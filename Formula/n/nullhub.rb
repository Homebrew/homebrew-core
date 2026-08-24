class Nullhub < Formula
  desc "Management console for the Null ecosystem"
  homepage "https://nullhub.io"
  url "https://github.com/nullclaw/nullhub/releases/download/v2026.5.29/nullhub-source-v2026.5.29.tar.gz"
  sha256 "e0751611af90b6f63c8a1020a4e951b18d3bb22b86fbf38a0267183a9325556b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8827e0e560b6d7bc76cdf3ba0b21b8244508ae056a7b3149e92809db1e9410d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69213fb5068b44644b456d2f3bf483289a708d0b9d327bfb289d02b8ae45f25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe466e3f72c5c168815c9fa76ec15b166a2f21523223fba3ce25e1d217547ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e79fcc57fa64aae0fd1d99ae9a2c05eb6bd6bc3ac252c022ec8dab5a3b866a71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17352f8b32b6325c032c08a52b60135616ab769a218fcdf1ffad27e5442f99c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a69037bc75f5dbbf2984c34f83b7518aeb5cad267249e2d665bdd26c0c7fdcf"
  end

  head do
    url "https://github.com/nullclaw/nullhub.git", branch: "main"

    depends_on "node" => :build
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion=#{version}", *std_zig_args
  end

  service do
    run [opt_bin/"nullhub", "serve", "--no-open"]
    keep_alive true
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullhub --version")

    port = free_port
    pid = spawn bin/"nullhub", "serve", "--host", "127.0.0.1", "--port", port.to_s, "--no-open"

    begin
      output = shell_output("curl --silent --fail --retry 5 --retry-connrefused http://127.0.0.1:#{port}/health")
      assert_equal '{"status":"ok"}', output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
