class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-05-03T11-21-07Z",
      revision: "b471de8d1882cae21ca84e98d56c2a5e2c321164"
  version "20240503112107"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddcbf5abb0f3bae77922c601c689842dd6fff39d8c049f0dacad38e70afe94ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7ad0547456dce3965fca8b8310c1fe823d22dea70272b958d71e3041ca22442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a719c44b3e57e273d5fcd22f1c4d4d6d383db535489c9244e1c9faecff4207"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce71b2d538d5fac1862e379dd6fd7c68a14f8958ac96774a39fb63be54a8820f"
    sha256 cellar: :any_skip_relocation, ventura:        "434093b11854eee42ad8c4985185ddcb2b8557c83e6c9ca64543944b1f11da24"
    sha256 cellar: :any_skip_relocation, monterey:       "16b58e4f994f4c096c1aeb5746782fddb0024be3d9599ac32d2d7a31d4c8b882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f40fc0e59d8592344664f0a91b1b09d9a8337309d3e3598bac76b2647767ab"
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
