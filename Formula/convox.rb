class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.55.tar.gz"
  sha256 "30987ad4c853ab01d32391654a6f83664d5c34d50634d8e94c5c02b7e284283f"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3183e2a1f0073e3d1bb34bb2ae42619cc41d1417c22e1d0f90842a45e8eca327"
    sha256 cellar: :any_skip_relocation, big_sur:       "50ca8828b005d51ef4a00bea84d9a9745793ffc10cc8b5f33b7fa8f704fc49b5"
    sha256 cellar: :any_skip_relocation, catalina:      "278df4ff596459ce2590f76235b7401114fb03379700455716c46421dd64330d"
    sha256 cellar: :any_skip_relocation, mojave:        "c1c961f520828b71308761830aa6dd5dbf4e9b7661e763af2fe10779bc4bec98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c206ec4bdef64b2a88f93a5cf6b96052b8775dc8d031ae3a16993278946197"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
