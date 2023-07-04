class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c44b4999604ff8cf65c9d747d4613ba8d42d003a8e2ded6a8adee42099e007fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eafec49c354c8d9cf04f5ee3a65cb2b3a1dab095760be02b1436a27f5de16caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eafec49c354c8d9cf04f5ee3a65cb2b3a1dab095760be02b1436a27f5de16caf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eafec49c354c8d9cf04f5ee3a65cb2b3a1dab095760be02b1436a27f5de16caf"
    sha256 cellar: :any_skip_relocation, ventura:        "6b58d13915544c291cc1d0d9617b58624d126b9dc1650f6ab95333cdb8ba8a84"
    sha256 cellar: :any_skip_relocation, monterey:       "6b58d13915544c291cc1d0d9617b58624d126b9dc1650f6ab95333cdb8ba8a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b58d13915544c291cc1d0d9617b58624d126b9dc1650f6ab95333cdb8ba8a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c793d39f2a6589d256973c297b6ef30a4e8e52b52bad82fc84d84a6bcaf3ab5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
