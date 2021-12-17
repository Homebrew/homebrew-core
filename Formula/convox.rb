class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.2.tar.gz"
  sha256 "6582301047db51bd0ec283a85ae6d3f0ddc7970620077444174a1871a12a87c6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2632c019cde8db1b7b5105aa0a386ec3e292dbe6f46edae3ac21c4b9ff6fd937"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25144def33f07e20566ec0af984dd9fce6aee7c5b8a0baf774203d1be6b26941"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f94fb078bb64d532befd6495894b15a71f4a59e59e2bf7c0f63350c11c33ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d773b483cce46acc91e5cc9909a13224ecc8c71775806771c673c685bb9798"
    sha256 cellar: :any_skip_relocation, catalina:       "79b4f519a5ae435a1ed308a9aef1047c20e9a012ed5f23390be5b9896676a194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3766e6bdedc2c014a7fd1c893ed0dcaec122ac8f0439a80f8fe4849806e5ced7"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
