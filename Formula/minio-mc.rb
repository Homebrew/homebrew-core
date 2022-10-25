class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-22T03-39-29Z",
      revision: "88796ea618092bb27368c00e2b387857945357fb"
  version "20221022033929"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcffa19894c14ffa9515f51861c5622a56b4e2f87e41f4f8347e05e31095443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0574221d811061e7c6d29be94f4ec6f6f61891f365de68e00bcfd33f9cc8572"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4f2fcfdcfb1cc0cdaf80e1ad142f1c4532231dd7438b8168c8a2c4d99544ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "b386de530fd8603502c1cb0fd2a1b0071fdf3e7cec0210b616f987d2e976ede8"
    sha256 cellar: :any_skip_relocation, catalina:       "b789b9b89db2bec41a801e3c983eaf0f0322e02ce0a50267037b36a333e7dc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfafef792c1d864daf6a592ca79517238bc2b0a1b64a1a2549de88e18e582c0"
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
