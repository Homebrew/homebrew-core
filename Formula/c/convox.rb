class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.8.tar.gz"
  sha256 "2ff800fc13e1ec899c97deaaf5b1bbc456ad79de86973eb1614177ac606d9cb6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c06089bd6dc099126ebb0cbd511bc4053c2a69a6a0e6f3516053d7f63e5ffa4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02b1ec68469c78e0aa7787fb1e36d63de3f5846b8f7710a4abcf194e4676a5ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9ddbc00d7b574bcdb8080292213193556b7fd6d4ab7904e33e1453438ed7984"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a00bfdd2024100028669c14d24394f556d5955fe9d3b3895f2aca39be3bbe71d"
    sha256 cellar: :any,                 x86_64_linux:      "059882cc23dd85c81e2be081cfd3c335378e4913623a97d9af54cd6baeb96a60"
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
