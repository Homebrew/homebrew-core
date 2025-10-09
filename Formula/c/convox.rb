class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.22.3.tar.gz"
  sha256 "fa50fe01b6137422c364e24f379766e6d7a3805108addf6d60580040b0ceb985"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d854d5f50d0eb7d7d2ad67037dfe8926dfbb099b3c22469fb130a5c649c43375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879e0dfec96cf6f300f4fc2ed4cf97191cfccb9ad26d478e3365550c2e930590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d645feb41dea049a4b5462d3c49fb8b0589c17144444ad38ed6a14627d4d9fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ab0c5d582e7fd724ffc7ceabf4b20c043d5c063d9340aa31597403d5f2ef65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab1949d63f4c059c95e4c82e5efaf82c284df0564177fb66f501a1f52033e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b6d4fefa7302b3e12c525a52c185be68498fcd64fe5359ad7a9ec96cd54b0c"
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
