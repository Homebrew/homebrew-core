class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-15T23-03-09Z",
      revision: "df68f5cf897d30203bfa3003c0882b3f76edcdd7"
  version "20230815230309"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a0380dd6f725cc84e989a2e6f8893ba054c4c52978ea8ee6d1d95d7346e8be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1629e1f753a97ea1d533db358ce5f0d1ec401f16654117aa6b11d20164a0f732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4ebc46c2fd6e07441d8f86e53f643a82f3771c453373bcf252e0141271c4361"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7907428ac994e0f1a2c8f1202ee94a6bc57695d083c3c4f5d68bd81b4dcd22"
    sha256 cellar: :any_skip_relocation, monterey:       "2551ab35feec3985b3e9c9b6ebe055aa6f36c2f04fd5ae645263541c109d1abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "de9f89cfcf93c4e40ecd913ef8e4ed2ce458a995d377d29ad11a1f0fcee3356f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041226974275c4a71d470e8b29a4e9f0af1b0bc41951ec32a48ad34500270798"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
