class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "0cc3b2ac8b30aa6d6c2c3df9289436b985c21aed6f986b025c7a4057666bd47c"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e7a20b00c13370e76d0a8b577b684db1e45a0d2a995431626ba1fd3efa74619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfce7faa55579b7bfd9876182f7fcacf0e9599960f491831982a0edac8b5547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61591938a1e79b411194f2039b0cb185a2d9e47ba40de13f824101033320e9a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79a3f280a8b44e9e738044de0c50dbfa649b2433ecdb920f4caf057d11b420b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a41b75f4e1cbb692f30e8486c4e4c520b7889c2802d4ffa34234b4365ec780e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d94210c52d82c0d045e180d5e0b777e33e5aa17cf4b6c48c94a7df748c2a2db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"ghostunnel", shell_parameter_format: "--completion-script-",
                                                           shells:                 [:bash, :zsh])
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
