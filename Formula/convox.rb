class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.48.tar.gz"
  sha256 "80ba78e471ac6281fcccab83c8dd52956f3e35fb15e41d78a92e847120bb13c4"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b740523173869753a3b43ec76ec8e028eef6af39c1f90a0149954c93f9200e7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2bb3e77077bc4c94f82f1f4bfc10128518fb18b3aaa16145fe315111e828efd"
    sha256 cellar: :any_skip_relocation, catalina:      "28f76e47ecc9b86f98a1d5c229bc8ad24c0d9863ac74c67ef823480df7465e04"
    sha256 cellar: :any_skip_relocation, mojave:        "58d17a811bc76d9f4f5c668eb42163ee38eefbd4bd1eaaf352965653e65f3a55"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
