class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.21.1.tar.gz"
  sha256 "90381390ab6ad506fc8a8c9dde31ca8ae982fb4257399182b03fc0bfa437a1e6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a19f7976ee2cbb25d16e186607f6cb3d542c6e29eded9fd1515ce222b603d63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c7e35ce6bb21e507a6f454486788e313cc73ff38c135657d7ab59cea6ce100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "066102369b099db33cacdb8f581c82fae132a04fb7dc71411b102565c80464e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b6b901d35996735c3389b422276bd9b88cf7e6174ea192acc3f67b738ab670a"
    sha256 cellar: :any_skip_relocation, ventura:       "1f7d45275015f7aca3a64626f3e76594c202bc4de96e1e031b5922463daac6b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "876da8f6ed823519add026c2575066769dd01516f0d12382bcb5063a453d3e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd4c53acc2c5e3ed8053478c1f1174a9492163b4d0f89b30902d4740074018b"
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
