class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-06-05T18-13-30Z",
      revision: "17adf0abbbca8a1d3153932a9b467a19c8371cc4"
  version "20240605181330"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4636b5f58a7dd96efa14a448731e7b4e5aee7e905baf41c055acfbeae3bc263f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10668266e3ba522f0abce68d48129bc4d607238989fe4d2ebc59b99b80093ac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d46bee0dedeb7a8808035755d6f5a94f2a6590fe331bbda17eb74df65f6945"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b168ca114e322891740634158e335770ac2f3d2d55dd2d0703077b90603fb4"
    sha256 cellar: :any_skip_relocation, ventura:        "91e9240670f599101aba8eb23c86aec7811c91b6312192a0444869a1235aca72"
    sha256 cellar: :any_skip_relocation, monterey:       "d734d75ba86127c077c9c647b916f4a6463f6379bb0f90f4f2f9b54b99e3ab03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a73bee233863b211e3c6985eaeaace353b40a7c998f55a4d744b243a8105c0"
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
