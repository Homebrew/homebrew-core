class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-08-13T08-35-41Z",
      revision: "7394ce0dd2a80935aded936b09fa12cbb3cb8096"
  version "2025-08-13T08-35-41Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de6f7f9346bc488230a9ad97bf4e756b2705218246c89a88a75125d7827e6d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4a41f0de492c2ac69846df380757be259e2d762219a1c5a80119ece845e487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2fe5e78c335c757898cb3574775c140c718bffe2ca4ba573df0a606944497c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ce210974c0bd2f273e67c10970ae25923326b31b1e7823aaeaae4aad73e8f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "06be6e6c3190957e688c8321892e4fe21118900564ad176ef24300bcb582853d"
    sha256 cellar: :any_skip_relocation, ventura:       "6e4576ab9c04b1d7f4a593b5329e126e09fd604c0c710be75a90edb6b21beb9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f02a6a7dbcdeed12b5ced2c2dc39d125181ab5cb75078ed9607d2378424b499b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8ddb10d84cbd05663a495bb04c778a3d5e4915b2b1c506cc98a6a2a1750dbd"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
        -X #{proj}/cmd.CopyrightYear=#{version.major}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
    end
  end

  test do
    output = shell_output("#{bin}/mc --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_path_exists testpath/"test"
  end
end
