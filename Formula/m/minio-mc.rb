class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-10-14T01-57-03Z",
      revision: "d158b9a478a6a5a74795f01097d069be82edfff6"
  version "20231014015703"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36622e6a974236544d5f0fedf47436d3b17102b736c78a845493d0c0aebbd7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4808632cbc042676f3299314a46ec125bb27a289ac62d5f6a6b1de4060461d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7bbda4a2c684650bb5e25550ef741b051ad9ad25e89d2d38aab2aa07e552d6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac2be3a432ac470819cd6fa823e6ce334476ffed3697ffb87962f023ae1c1ca"
    sha256 cellar: :any_skip_relocation, ventura:        "386ca0cdb819de638548444d1bdd7631a7dbc7577aa65dbfdfbdf368bbe24bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "9faa074630ba1cf9bd746bcef1a33d5c3f51e98697e18c7be583c88a8f118f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee110be747649ea53133562855cd768a927c3ad878a423643e3ff410b84f5fa"
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
