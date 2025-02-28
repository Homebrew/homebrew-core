class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-02-21T16-00-46Z",
      revision: "9eb205cb62c6466887037397c5aa202b53d10c78"
  version "20250221160046"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99975c3d09d6047d88cf7cbde34ff8d95d29a84c84844031f070d6c411b9366a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af71190864eae012297adfaf714d9e557f752d854abcb1f3f9e8d7d5a2d3b7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07161470ea813b1161763c978b9f36076c81379406535101c1b499705b978698"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3990f1429117e2450e6b96046b5c1fe0b190674dbce1dbb4d6ff5e77fd32f8"
    sha256 cellar: :any_skip_relocation, ventura:       "caf508c21255eb9282942674491589bbd073a55e7c0e3d1e80142b05beca9ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02adc351a1059a9451798237418a7e28e6f979cf6f4e45436ab3d8745f0c583b"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/mc --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_path_exists testpath/"test"
  end
end
