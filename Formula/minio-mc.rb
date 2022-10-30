class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-29T10-09-23Z",
      revision: "929062c86be50d7f6350ab2da929585720f4fe74"
  version "20221029100923"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0298a11f1306533f0c403aaaee17a2712a951ab1f43cfec05ea2a9034f336ec3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96179a149b7e981e8903788e247ead9382247280ff7bf9e8a47741ee7c6ecac8"
    sha256 cellar: :any_skip_relocation, monterey:       "d05210a2d76f3a87ce75345e884add7c9efa033b69f064fce29080d3008a404d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c600708ebe1c6148046218366aa3e3dd833cc2d8c766cf6e631f897393079cbb"
    sha256 cellar: :any_skip_relocation, catalina:       "6491b0698621f015cbcddc0f34448e7969b1352c8390471265098a1c5ce00b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da3df46fb4425b3ad0c59ecdf7b6fe4fd2a360d50e472bbef3117d2c9d81120"
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
