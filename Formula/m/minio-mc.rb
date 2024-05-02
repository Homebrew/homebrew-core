class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-04-29T09-56-05Z",
      revision: "5b7b2223717a32ff01d63d57c2d040a719ca581e"
  version "20240429095605"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cfb54445572245517fe3bdd2a08706555662186358f847646c969d772c00669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cf04104f1f4d8ecc3be6b9a2b47758b3885190f44a6baf2f331b6a2fc9c560b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3092300db2a8a30d455021b162f8add1ad4ec5bc2dd9100ee0b1a98c6ff6eb88"
    sha256 cellar: :any_skip_relocation, sonoma:         "80e8f388ba8fe59cc15b68a0bd77577cb2402375773eea35ea99cade96e88108"
    sha256 cellar: :any_skip_relocation, ventura:        "9a25c93b35a6fadccf78c92ca964698f98bfe52485a65290425bc3795a0fd46c"
    sha256 cellar: :any_skip_relocation, monterey:       "403af8396f30c10d21867baf1b9e62132625f1b21633c0e75083c97dccb3ab73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8c397e9f633a273b91db58724a6b093b3fa78bef6b851e3debc77c4eec000f"
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
