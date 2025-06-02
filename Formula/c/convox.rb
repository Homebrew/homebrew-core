class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.21.3.tar.gz"
  sha256 "2dfbb51b073b335adb505ed5c3a034aa34ed62572ea9e618b176559624f3e4d3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f752f5389d47373025f4ebc653af95d1dcde8b69d30acc0136f5b6ee0dc91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c15ee0569577203170cfffbfeac14861d4dad6b08cf17165c7fb12d8f23d6319"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5a5a7061660e85fbdc53bb43d7d524dd39e9813e96d0344c405d339f107ad62"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dc2f48bb43a73b3703a834c3c1d19d4b7e0cfbdf3189b0b1377da5982cf8610"
    sha256 cellar: :any_skip_relocation, ventura:       "ff644f619b1230d40c3e6693f60c2be760c60700e588d7f2e936ae7783fb7dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb223f669197c326be9d0068c97f652df42b3f3807bd5123acc9a2d0e19eb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c0b3b5480c4d4b7fd2f3ab714fcdfa6e56140e02784c91852039ea775866b5"
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
