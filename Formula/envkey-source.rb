class EnvkeySource < Formula
  desc "Set OS-level shell environment variables with EnvKey"
  homepage "https://www.envkey.com"
  url "https://github.com/envkey/envkey-source/archive/v1.2.9.tar.gz"
  sha256 "3f4684eea7e83ac5148a47a5f464e5c6930e1555cc4f8ace0cc807f18c15af7a"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "envkey-source", "main.go"

    bin.install "envkey-source"
  end

  test do
    output = shell_output("#{bin}/envkey-source").chomp
    assert_match "echo 'error: ENVKEY missing.'; false", output
  end
end
