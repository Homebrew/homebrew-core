class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "f1e8b65f43d288af571625525cfdc3d9902f1747d12102fb38650f0e5b852198"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0f4a4265805b05ff682a34669065ccb6bc886cdb94ce080a10750e4341d2543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80eafd6043b80998e8889221d7a32073b3d03a18015a31a2c342e37b463a61f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe26a0eeaef9d0d9864835708015c8c9e94f35815338e6003c8f4151799a67c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae889bcdfc2d2f2c2c520d9e96ddaf3d4ea290201bbb6e20167e2d464e293e6"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc27d9125548378f046baaadb2e850972f0d47509b2795eae0485aa190b59fd"
    sha256 cellar: :any_skip_relocation, monterey:       "5082ef25bdc93766f679cbf3938155284aa5e3338c7b42ed9512ee1c01b03489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e508decfc49cd05b781ca1e77ab2f322531372e9e933aa98f9639098c7fb0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
