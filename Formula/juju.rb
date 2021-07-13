class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.8",
      revision: "f4b4ab472fc05ac58d94aa7a9110b5925709e6a2"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "079133244025b008da3555e0f172ad71ba3070b2e7df1f8a17e019394892a6a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "04b07f5ea0f3d32c9e84c0a7b6970d748241cc614198e34c63a7e15e2604f61d"
    sha256 cellar: :any_skip_relocation, catalina:      "8b4aeb9915c60e36972379e4bbd742cb6710362412cbf959111ae0c01b010f0c"
    sha256 cellar: :any_skip_relocation, mojave:        "3211f69083e267ebd5f02ae721f9a8c199744a709e2a73470fb941d71f99a67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9dcaa346c102ae32376f8d56ed491d62822544cc4c4646f2a72c7b81154bcb"
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
