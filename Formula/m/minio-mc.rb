class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-20T21-07-29Z",
      revision: "9043bbf545d244b2dee9eefc5031d5dca1ccf78f"
  version "20240320210729"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e133595d5c0043f7645386adf14ad866ef1a19ef1617e33cc3002e7ac9f6aa80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fef904ebefb2ec27a54a6b2002d4207cd5848f23d63e2b202a403345b25cbd17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3908601c2b88ca903b214b4d9ecd9797621999d669179dc1f1c430fe21949c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "024c9c33affdf85ed55f571bbf58b72421a0d95243573ada66b4ee5062eed18f"
    sha256 cellar: :any_skip_relocation, ventura:        "b9b40b20db118d67c6bad65d2506739d2065306998e3f5de0ad98cf998f1b340"
    sha256 cellar: :any_skip_relocation, monterey:       "636f3ae706190f22f0c78a2877a4dab5af35f141744ffcf9fdb306a1e41f7c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbba41d31440f6533790800bc2420b270c94508505a56b8b0a9ecf6fe95dc487"
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
