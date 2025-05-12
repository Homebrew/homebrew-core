class MenderCli < Formula
  desc "General-purpose CLI tool for the Mender backend"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-cli/archive/refs/tags/1.12.0.tar.gz"
  sha256 "7b68fdeef96a99ee4560cb9dccd673658b27e2f3a9be2e3451d204c50395caa0"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "xz"

  def install
    ldflags = "-s -w -X github.com/mendersoftware/mender-cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-cli --version")

    # Any other tests would require credentials and logging into a Mender server
    # so we just test some elementary error handling.

    # Try to log in with no input
    output = shell_output("#{bin}/mender-cli login 2>&1 </dev/null", 1)
    assert_match "Username: FAILURE: EOF", output

    # Try to log in with a fake config
    (testpath/".mender-clirc").write <<~EOS
      {
        "server": "https://nosuch.example.com",
        "username": "foo",
        "password": "bar"
      }
    EOS
    output = shell_output("#{bin}/mender-cli login 2>&1", 1)
    assert_match "Using configuration file: " + (testpath/".mender-clirc"), output
    assert_match "FAILURE: POST /auth/login request failed", output

    # Try to list devices not being logged in
    output = shell_output("#{bin}/mender-cli devices list 2>&1", 1)
    assert_match "Using configuration file: " + (testpath/".mender-clirc"), output
    assert_match "FAILURE: Please Login first:", output
  end
end
