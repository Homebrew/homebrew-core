class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.23.1.tar.gz"
  sha256 "109c1463b2c767216b5029f9e4c23bafd3d4365a6a10f7b324178bea139030c3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcc1f6fdbd063e2bf036cd206d358964f62a3eb65d7f14d874b814f1136ea995"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4265488692c3289ed24e05f6b4a745ab1d33e0d9f35226290c7bd4cebc097f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42bafa1998e6262092535dda7fd1a0b434cf6acc188e7efb417402e432413eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6794c454ec3d120f3e7684018fefd897bad0c2492a851203404a2fcf44cf48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a02f0b0d3566e3c5b95a606e595bc2acdba2c1422c78c2ec022345a97d692492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a7a5771ee27bf46fdb711d5800c9c0e6d3761348544a8c3c2e6e29e3c5eed6a"
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
