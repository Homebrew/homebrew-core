class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-07T00-31-49Z",
      revision: "33a43e9c6e924bc6ffe289ead600077a393e8056"
  version "20240307003149"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1de2d025c19bc40c2374166fddbeaf91e25f4b77e95d20ed6170229eaf4828d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8103a719ce84017b6eabc7efed8bc4fe1fe16cbb55bae0fe389f12a411f5b113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db207412ec7b8f4f5bc384f8c87896ee36253645d4151707855808e82c8813c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b26e63821d647aa1738d8249da0a961aaa65f1caed2d0e973a25fbfa73865b71"
    sha256 cellar: :any_skip_relocation, ventura:        "b389aea1d38839e23b78828b723eb3823b23929c9b001f5fd499bee61f026fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "76c33c35d4716216de3570e782207ccb9f584912bb0905442027dd863de8c620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64fcbaddcc0c43c4486f8fa9f7ff893b76e6171a7c54a164ce01d9cf18c8d6d9"
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
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
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
