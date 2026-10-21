class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.11.tar.gz"
  sha256 "86e39d346bc6b923cb9cf3ab5184284955a48e243a76e806ec7ce0c66ec92ed7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcf9c263c10198b248fec8cd9c60eea2fa78c84a3af92e945ecfd831466135c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "601ece248be0c90ee501f6f79c7bceb4e94b35c7ebe583f2c7457e31a7ea7524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b42176b4148e0a5bcc5dd9460e1073b1a4cf4f841051e825f671333d64fddbee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c218c86d2f3f128dd7a77117af9e7ee4db90ea549be9f87d2499d8251d6b17f5"
    sha256 cellar: :any,                 x86_64_linux:      "6a1d559d9c5261b92c2e38ad777e23e7d960494c49a0266ecf5817d2540591cf"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
