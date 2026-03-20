class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.23.4.tar.gz"
  sha256 "43307b78a5c1d7e7aa74e4907e797f4712e983a40680b334144befb14d7e6fb2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1876d66f7066a4f178e4aaa5579ca34af8d348bc67a8f22a21ac9aaa977d7ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee9b6dc0adce32bf58225a74147f75bdf40e89a9b1d050103e179a32ef55062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b2fd3575f44111d79a7ff15cef3c1f141312cb73c5836d9b7494804258eee11"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2fcd1a54c4bd2a59647319412df09a0caf29364221b5c4f3ea821c0e327ea06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faa014ba220ac2251ddef9084a77cdcc1d7bf7b8b3be82f9d3539b6661b45595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb42261ebfe0cfdcf19a128430e1ba3672546592802b4315799cfbf805e198ad"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
