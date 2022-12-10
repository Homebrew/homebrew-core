class GoPassboltCli < Formula
  desc "CLI tool to interact with Passbolt, a Open source Password Manager for Teams"
  homepage "https://github.com/passbolt/go-passbolt-cli"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "5787c350aa4a421cb7d811be7e2a465f0d447d5861172a7a0e6b54c2267d2f07"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/go-passbolt-cli", "help"
    system "#{bin}/go-passbolt-cli", "configure", "--config", "./test.yaml", "--serverAddress", "https://cloud.passbolt.com/"
    message="Error: userPrivateKey is not defined"
    assert_match message, shell_output("#{bin}/go-passbolt-cli --config ./test.yaml list users 2>&1", 1)
  end
end
