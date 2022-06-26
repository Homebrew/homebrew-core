class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b6507b24714dee193bd04be18fe8658531d2b0c0b9f6f060ac6bb387c736009f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "566b4a783ec4fb5a716902291fdf5f56131f3245e85bf169c9cafc2af4212594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30b67fd89b006c7a9f1f9fb679b2f2473de40399dd16957635c08b7e5ef42186"
    sha256 cellar: :any_skip_relocation, monterey:       "2a6fb1702f3ace98d1d961d541a2c5f1fd98e4bb617f62de3e5736128b90d219"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aaff024ef619fb143f00fca215ed26324d6c4dfc3445e5fd5a911f4f2230a08"
    sha256 cellar: :any_skip_relocation, catalina:       "f767babba807bec04744e61d9241e178d42caaa4d348e0a526785da7952d5a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b9f4b706b741ab5ab9ad9a9c4c7ab987a7502f5d5598ecca8afb7969ad2a59d"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
