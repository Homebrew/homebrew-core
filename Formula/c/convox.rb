class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.23.2.tar.gz"
  sha256 "c6e640397cb80c1cff94a2a209085e575ebc4a17b95001b4adbe94ac783db5a1"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3711254f962e1d68cdc441d5493c5ac0159c44d67761cc4ea547e6efd559be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5175759fe29ba20f47d759e14e82e1aa557eb428b35301d9a4132bbdda8209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f851dd2eb220ccd03afbae1c3605a28f754d3aec17cb88d883889c1caf057546"
    sha256 cellar: :any_skip_relocation, sonoma:        "612ddd815e6248fee8d906c6feb944034e48a677e711e750629c3a88308bb90b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877c532f71cd6f60a874d49f01508649befa408f01615ba525533dd3fca16b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89dcea7b92802a83309f02b9c501a5211882a5559f8f341b8bb6af944c876156"
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
