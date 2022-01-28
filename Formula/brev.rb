class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "8cd6d5ec12a6f2adcf8b45dff5fbe2b2964700cf7dc03cbe323bf5204900f31e"
  license "MIT"
  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"brev", ldflags: ldflags)
  end

  test do
    system "#{bin}/brev", "healthcheck"
  end
end
