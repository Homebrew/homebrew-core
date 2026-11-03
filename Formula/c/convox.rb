class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.14.tar.gz"
  sha256 "1f22b9d5bcc8ead949c1aa5520796379d4ba683b8f329d15c72692114e3d545a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f0b7411f570f713834f381ee0ea645d786e9171a2089d3e52ae50bdd05d3809"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "815dbfb986f0792d4f96417bf6f5af2e5379610725e1ef632950e78275ace70f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85458650e6f99b8c534f6b9feace9559d50a2e272680bf29e1f1f96cace38b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa17f9c055ce70c522c665a7c16e85f389aff7232c44bb1a97785547e3f94168"
    sha256 cellar: :any,                 x86_64_linux:      "97ca18d0d41c04b18c19b0819a849d3dd4f0f5e6d610475b34959b11592d7db7"
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
