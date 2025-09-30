class MenderArtifact < Formula
  desc "CLI tool for managing Mender artifact files"
  homepage "https://mender.io"
  url "https://github.com/mendersoftware/mender-artifact/archive/refs/tags/4.1.1.tar.gz"
  sha256 "d0d30f3624caf99d8c6e70e1f3a99cc589e9d8d63ad8b46605d1290457d9ab3d"
  license "Apache-2.0"

  # exclude tags like `3.4.0b1` and `internal-v2020.02`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a87818d17f8830d3f842fc6a8aa4638b6788c26c8a942901586119abad0975e"
    sha256 cellar: :any,                 arm64_sequoia: "847523d847a7ff0c5e8e9f76c7937a21cbf0c1ddf9cf36baaea1cbb5e94aa1c9"
    sha256 cellar: :any,                 arm64_sonoma:  "f324d58a48858f0e029be484527e0e23ca775b6e71fde18178ece9396e688e5a"
    sha256 cellar: :any,                 sonoma:        "9cc1775e97b6afca16ab81cf9d045b6c35567450cbfc351de751361f4344ef6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0467d43529e038c91240526b314f7e6ecede9fac47d3d24cd98e129e0ddb16"
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
