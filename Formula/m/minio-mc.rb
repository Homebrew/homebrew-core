class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-10-30T18-43-32Z",
      revision: "9f2fb2b6a9f86684cbea0628c5926dafcff7de28"
  version "20231030184332"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73df7a3c97a134014df5ccdd788c971d6f4cc9a8bd5dc74f07c8f040c95e99e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "901599ed5e4551f304be74699206416977620c64be37887acf178b386c918dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf1671eecb2f09eb08416232ed5cb7412adf25435b81d4c6e93b3e14b18b7195"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e30613f3bf509ca14bd1aed3e553d030d7ee2ceb58112da5dfff3a4ac3e23f6"
    sha256 cellar: :any_skip_relocation, ventura:        "9d6204f40dd6217a5cdac4bad416233904e7351367b4457b05e47a2bdac80e74"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2249a1d61609e04aa855384ccc9d71b700ab7110071fcea160443234b5a53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebccb9bc061fe941089ae27a0716432f2768b2e46d1d1fdca90a1b1a151d4e04"
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
