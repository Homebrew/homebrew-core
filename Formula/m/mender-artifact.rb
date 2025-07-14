class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.1.0.tar.gz"
  sha256 "d82cd2f802033d53f2e947ed8d9d6cdd7a036fadbd92a2696b72122bd2070039"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "80224c8592a5dc4827fa0a910636f7d34dcfd38bae207b5a4fdb2f948a0037b6"
    sha256 cellar: :any,                 arm64_sonoma:  "de1ae9470958c874522781e728982d9cb122fb91433137084fa5a8f32f97f853"
    sha256 cellar: :any,                 arm64_ventura: "36bb71ef0ae85788b6d791a694cc1fa1421998b0fcc6b393385f02b29d57c115"
    sha256 cellar: :any,                 sonoma:        "99f483948f3b03f67872a6e376565e72847b01bf8c9ef88f5b9be054d8336ed2"
    sha256 cellar: :any,                 ventura:       "c3a172ee1a0db147f6215f064a1c33cf0bb86d9ff8619236b35f9583574f1e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07214f6a3d3292b02f755f8189fbb5acc54f57c3dba65ece86d8feb5a3506dd4"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "dosfstools" # fsck.vfat for vfat file systems in artifacts
  depends_on "e2fsprogs" # manipulation of ext4 file systems in artifacts
  depends_on "mtools" # manipulation of vfat file systems in artifacts
  depends_on "openssl@3"

  def install
    ldflags = "-s -w -X github.com/mendersoftware/mender-artifact/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # mender-artifact doesn't support autocomplete generation so we have to
    # install the individual files instead of using
    # generate_completions_from_executable()
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_mender-artifact"
    bash_completion.install "autocomplete/bash_autocomplete" => "mender-artifact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-artifact --version")

    # Create a test artifact
    (testpath/"rootfs.ext4").write("")

    output = shell_output("#{bin}/mender-artifact write rootfs-image " \
                          "-t beaglebone -n release-1 -f rootfs.ext4 -o artifact.mender 2>&1")
    assert_match "Writing Artifact...", output
    assert_path_exists testpath/"artifact.mender"

    # Verify the artifact contents
    output = shell_output("#{bin}/mender-artifact read artifact.mender")
    assert_match <<~EOS, output
      Mender Artifact:
        Name: release-1
        Format: mender
        Version: 3
        Signature: no signature
        Compatible devices: [beaglebone]
    EOS
  end
end
