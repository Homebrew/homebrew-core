class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-10-08T09-37-26Z",
      revision: "cf128de2cf42e763e7bd30c6df8b749fa94e0c10"
  version "20241008093726"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76156139bdb5d0cfe70f8808195ece6fff2a1141c46f01934ca15621e0e29cb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e77d5e64d9c6cccba72908594ef18a063dd4931d18cfcb653e7f4cd7b949ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ed73d511338ae28fb573fd3cfcff0310d1f8c1b28bfdc9ab345a15f295b2d3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49770a9a71243553a3a73be10a7b6b33e2db515f021313be342250e0f0e016cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f005a6b853a68b1e5087338c1b629782f39575acf6e829c923b17e56171c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff723cb10d169137f749db889cebc0d44ddc80a7c7d8e49cc1b6739d750ef7c4"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags:)
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
    assert_predicate testpath/"test", :exist?
  end
end
