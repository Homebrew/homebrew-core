class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.10",
      revision: "75aac44fe3d4df90df48baa0b5615d9d9fc1f3ee"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03f2e21877dcd7c7225234a08ad4dee5b09b8ce8733fa7edaacc2e3d6ef65931"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba764cd731147220894a14b4a15903f0ae3d89709ae59a7a50bd8e719dad145b"
    sha256 cellar: :any_skip_relocation, catalina:      "e20cedcf3ac9f187aa1a77de50684473aecf3cacadb79696925ece7ebb31ea00"
    sha256 cellar: :any_skip_relocation, mojave:        "fb52d72c406d415cfddf606f78be0b3a3433efdd8ecdb30c5c1e30232805250e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfd60f5bf2654191b0111ee8c4a10828c6292557083670ad7a95e3ee946e873"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
