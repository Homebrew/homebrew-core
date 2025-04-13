class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-04-08T15-39-49Z",
      revision: "e929f89ceeedc48a45611382be9882db0bf1921d"
  version "2025-04-08T15-39-49Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d47611cdd1e20e37e9d20b884398aa92254862a5f3d4b30747e27ec5cb46606c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f52ff5c1b008a1db862983a959b344a9c6833a64204258bcddbb168ccacde78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41532f66f88005bf71b69485b39a4247bc7ef2593da2b3f8d14870772a22e763"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c763af37d54b686e3562dd2811d8fd9ab7e6c37160fd7020ba9a443c4806666"
    sha256 cellar: :any_skip_relocation, ventura:       "9d39c55870000683f8984e1d022773e64328703be8d4bad658d46d53ca9cb33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703abfe10c73bb23bc538f868c95deecd8625d83e64939ddc520d33fabab98a4"
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
