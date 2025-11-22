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
    sha256 cellar: :any,                 arm64_tahoe:   "8f1ba6b750a0ae35277fecc1943703ffdf0e88f0f6325f24737dbdf3ffcc4f41"
    sha256 cellar: :any,                 arm64_sequoia: "b5e7d27ede4f0b37225e0b5f54e90119789ed0286e84d178715e3c33905c712f"
    sha256 cellar: :any,                 arm64_sonoma:  "81998e6a9f3d7a6ffab24b3a25ece7aad078bff7b7ce947ef292b288222d5cb3"
    sha256 cellar: :any,                 sonoma:        "ed7a797e3672c980e1b357e81b55489769234faef5c6518bc37664c8e4721daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c664370a38bfc8568520d9842f597bac4dcf692d534a63d0d1fc6ff866a7915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10bf572305613feff2b31a01d442a87322ee7dc2657da69942c8692a8d6e277f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
