class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-02-08T19-14-21Z",
      revision: "bd925c01a1ccab367993f20c251b7bae9d22f8a5"
  version "20250208191421"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d895ac74f1b388b348296f9d7b33f9fc1dbad5e0f79204eed1fbcb93acdbea1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e168255f885be5000160d773c1765f7e6b646911e149186b3de0988ac7ced3ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "656d677495820761d651cd318c7f8819dcefa5a510b60c3537a3fe3f8eaed86a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a83e8ee14123cfd6ae43229b6c5717d168b6252866b37827bad0a8fe3af6edf6"
    sha256 cellar: :any_skip_relocation, ventura:       "4bc572f079cf8b3a002c9696c358d0d135056629d83eca23cbc9e78bc8dc7beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a89acacd1ebc35063633c9162c346aef4cc626df5bfd4e04a386f03fd5fab24f"
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
