class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.6",
      revision: "10377f3a20c2b0f7196ad5944264b69f048a3d40"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03c74ac24c45b75e6cbdbb277aa325c1073d8a4e548dba58c21ce8747f11af83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941942dc29f1d70369dee3423896e86d98dc93ea9878502c2e2b6ee09a7da1dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25d01043a2b4a23118ab1892287c9994d16ab4b79712db9abee924192af5e0af"
    sha256 cellar: :any_skip_relocation, ventura:        "bb2334c6eb16010d3b5c2b291fbd6d61c525f9be53d8c9138d601772c9917920"
    sha256 cellar: :any_skip_relocation, monterey:       "ca024de6aaa786a13bdaf9d86cb8b6e22639f0d50242b913901903d7314ef246"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9ecc1c48d0982eefaee8548d6770677ae4cb6047cad76aa4f71ae766918b26a"
    sha256 cellar: :any_skip_relocation, catalina:       "01150540e8654c348875f81d4555ad50b2597033d60660f6afa57418a1263e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd3972b05e57bf1be14ec1a08ac77f83f37eaa7106c8b06d91c7bd89cd5e895"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
