class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.6.0.tar.gz"
  sha256 "f4eb80a88b07d97cc237288ec2b816fe5d14861d42291f406368718bb11efd58"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7ce77de373b2e4d41c7588e67710f711944b5b7246fc430b95923319968261b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bde4c7b1f25beba04d44208aa485e555fbaad77e993bb30932479e091cd6db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d436da5653db0146dfbd8871565d90d27f5e496ba555f3cb0b5a87b8de436f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c1f266699417752f1ce03274d376b75361b63d4a68c28a26e111ed1494d1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "4fb5504802f6e2e34218924d352cb55fa6682f13e1a4692e5d40d0f9105b106b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffe4dba900aa76360117b7efae4dc321d74258b4da995921531aa0bc28fd333"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"

    generate_completions_from_executable(bin/"ignite", "completion")
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
