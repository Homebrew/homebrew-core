class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.27.2",
      revision: "402c0b3815dc3f2452b1427fd23a394474ee513b"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0323d354c5d1ccb4f44d97897e398fe0dd91acbe9b45e4ccf8b59dd46e24f66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe4a2f09e7de00784a69484655e8912c03f82a0b0d273d5484733b3c5d6dbf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3552dc6a556565cffaf388501cbe2814eda0a3adc5adba8db56b7e23b51f18"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6b7d31189fe8c6400c27387bd0b86b7585e841cf0480141913bcdc593671a22"
    sha256 cellar: :any_skip_relocation, ventura:        "c9f226780f0e87484491e4633083ca5bd507d5773f2a79808cbb7983d9aaf9e4"
    sha256 cellar: :any_skip_relocation, monterey:       "85d1260d91f2372a40ad7fa7ba8783f47c925d3862dc8b261601b0ee17e92d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4806cb66d2d19aba82cc548e9496e3e89e78b78b8dfeb991c33dc484830f0ed1"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
