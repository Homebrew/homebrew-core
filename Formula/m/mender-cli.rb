class MenderCli < Formula
  desc "General-purpose CLI tool for the Mender backend"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-cli/archive/refs/tags/2.0.0.tar.gz"
  sha256 "1fda34045cdbe9914f04d7eaebc0933f7d14c2952dd9c149f278479cd47e37fc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8f0671cfe824e3f01e2057b81f12836e55f9b0b8fbf055636189d197bcd3af41"
    sha256 cellar: :any,                 arm64_sequoia: "5e0e61309b5cd8784776ef9edc0a2e3fd7a0c2af80e5006aa05628a1d1d512eb"
    sha256 cellar: :any,                 arm64_sonoma:  "50ad0bf3c654112ea0c46b288cd00d4a80db67753d2dd5b854687c655e003cfa"
    sha256 cellar: :any,                 sonoma:        "984ab3bb03029a0d1c71f7da55fdf46866e3aa2dbfacdab2bbf1f87f0311530b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce65a9c8f2dec521cc44bd235bd32794f842f6952b17fbce95443b3d7859fca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b31de68de7647a35266abf1034897a691f8e097e7f36a47c3f3f6fcf02626f9"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/mendersoftware/mender-cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mender-cli", shell_parameter_format: :cobra)
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
