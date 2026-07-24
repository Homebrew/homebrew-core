class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "7afa2128bbd2fb2a7c33f4a9b6c2ddfe26a370017d9eb8a0dee904c49f7e915d"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    assert_match "Available Commands:", shell_output("#{bin}/betterglobekey --help")
    assert_match "#compdef betterglobekey", shell_output("#{bin}/betterglobekey completion zsh")
  end
end
