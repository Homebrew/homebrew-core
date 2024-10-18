class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.19.2.tar.gz"
  sha256 "36d3885b5fcf2b26401288aa4bd9d1eee045f993b747e79648ef59967d52c6ec"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f87df5f67f13af01a979a58e45f9b6f3d7ee6eb67ad8200be6b9af14edefbb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af4d6f82f557fe485d087b6ac7190b541b7e6c6bf5c0d58f4b3402359b3e973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d0f461106d58ed101816fda5c84e1b9d2f163b3156e795828a925dd3c284dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4c2125e368510657c5c047c45e2fd8ea241c688a91b36911488d74a64af24f2"
    sha256 cellar: :any_skip_relocation, ventura:       "ab5ec5b5fb759bc903e424eb0a746dc1b47e3342d0f9fa28bc9d49a76010d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1fc415db6ff906fa0c11863122cb57e32ef27b4efa8e91806be25272c1e0f0b"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

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
