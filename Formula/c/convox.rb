class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.2.tar.gz"
  sha256 "890c05b7e49fb9cc9c0a1c24df5ad7fee672931fe9c902e90f7052706652bda0"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8521623ecaa6d9d4bdefa8c6212dc1220add4ee700f67928ff7a6284486b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4fdcbfb1d718cc91a69147ef3a3158d5f2ea3b979eee3d496b59ff46048509b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a9f2e1594ff71aa788fca6feefa39595d4c8f2f539665faa5bd02ab658c5bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c864b2d93a7cfaa91ad28a73e776a876aa33ad2c7447f69f0f735c04f8a4feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae90e10d05d466c7f7015732e93b7eb306b93102c15e6d0b62847d11fe6f863a"
    sha256 cellar: :any,                 x86_64_linux:  "2ecd59444c834c03ce8175c681dcfa937cfd5b771a31ff13d1235e9309bc8de9"
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
