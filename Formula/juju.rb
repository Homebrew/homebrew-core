class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.16",
      revision: "b84c5592b1036265aa1ce28b1e40b79c3886a21a"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b4ca1a26d105d17d91675b317e7c8483741b7484a519ee0cd7c9986de698726"
    sha256 cellar: :any_skip_relocation, big_sur:       "c66d25f0b2ff66ae22e601afc6a29d663077b0716f3af0fe43a7581a4d2b8cde"
    sha256 cellar: :any_skip_relocation, catalina:      "501c989c4cbdb5a24d3e8c8d6c1838b69330c07266c7d764712f1e6807dce614"
    sha256 cellar: :any_skip_relocation, mojave:        "7fca8357223fc1b86239c10d451d3c61feb27620b49beb0e0392ba474cfe0ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805cf11a774f6dc54ce31b285f2cf124c62be3b034a40679cdfaa20e7b0a74d7"
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
