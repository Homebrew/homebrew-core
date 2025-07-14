class MenderCli < Formula
  desc "General-purpose CLI tool for the Mender backend"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-cli/archive/refs/tags/1.12.0.tar.gz"
  sha256 "7b68fdeef96a99ee4560cb9dccd673658b27e2f3a9be2e3451d204c50395caa0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f6684645028a62edf8e62d7dfb7845b7aedc474830345cea55e635abf7efe75"
    sha256 cellar: :any,                 arm64_sonoma:  "fe129f50a5e78d44d178a5e802e853f5de0e164a0dd7cb8642cd1bc08423e0c9"
    sha256 cellar: :any,                 arm64_ventura: "c76bb683aab7e297d331c780d81520a954fbcd3e331370290f0fd6ef8764738a"
    sha256 cellar: :any,                 sonoma:        "e804a707060777c0a9ebe51378368a7321097a3ca95171b5f0f06e16dfe33be8"
    sha256 cellar: :any,                 ventura:       "6c5da0527d144a99695189ff297fb626d8fe9c7115488dd68a0ccd65ead01fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694e117ca7bade40819fb48b43080babbc1a439bcf111ae61310f710ee61fb5d"
  end

  depends_on "go" => :build
  depends_on "xz"

  def install
    ldflags = "-s -w -X github.com/mendersoftware/mender-cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mender-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-cli --version")

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
