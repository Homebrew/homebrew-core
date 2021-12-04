class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.21",
      revision: "8a154b7d629f6d9c0693aba7accf255789996c14"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c71aa36c7ae99e9de9f8d84240b817219dd401c3fd674c793d4ed1a6dd1bcf50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f245ff71e81b4548c8323811654109368d69744973da85d7a3295e3f57f1674"
    sha256 cellar: :any_skip_relocation, monterey:       "facbabbedaa46f8bf47f4c8e9569f4b90c5d4b04ba70bcb0a2dc5d7c2afc6d8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9106bbf5f179dbbc554617a4b628c80eec61b98cd73118d3d052e7507e87b3c"
    sha256 cellar: :any_skip_relocation, catalina:       "6910755ecce323f640060ba8847737588962d6551fa8fcd4a872c58a66dc0f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09930319aceac89bf6d1fef70f2dceee883208df783e0655157117c10100568"
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
