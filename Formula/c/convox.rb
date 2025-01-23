class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.19.6.tar.gz"
  sha256 "2d0dcd29065f73480698eb3ceded8089d652bd1531a17b172419faeb4dbef410"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bddbeaee8ffc3d6fc21c7ace83396e4df6a2aaafb4c6253b9ceb1c726c27053a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83460fe7e661a37e6c0ce230e22c78445b84a6654ee2ef0129f2495b49ce7d55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01a478cb6876ba848fcb141b5388755adb1e8ab1347e16aff315995f69305375"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2dc5233ba7268f8033a611042c24d6aa22533d0e9a94dfb5a978693c3d16594"
    sha256 cellar: :any_skip_relocation, ventura:       "ffbfaf14f7fb77f3f6460ce90a5d0313e8927029ad776e1b1eaae26945136c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a238d85b8f9b017abe96597aaf55241391b2a539316e69df7aaf8ce0319ff6"
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
