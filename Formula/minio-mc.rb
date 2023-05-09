class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-05-04T18-10-16Z",
      revision: "5a0d5116f4936f25b7a1a67c8119cdcad6112cce"
  version "20230504181016"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39c957ef8723ccb0effe7c1739142f51fde0fb9e9b6a4cc8c5364b1fbe0c500b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15ea6259f068be280574448994e3d3de48aab87fdb25a2b370e5d55afd6ae824"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c328ea207fcf6b803e8f15900932b2e531f2a84d2a0dae7d5e551925141d67df"
    sha256 cellar: :any_skip_relocation, ventura:        "033f8820b4beef448400478943089e33c5c727bd7846f8f433b9d4085ef7f484"
    sha256 cellar: :any_skip_relocation, monterey:       "72389071e4eb7b581deb40917661f2d22358c265270bd64be4d43b1e9f89be3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a16b31aa64881f123d00b1cc0777a99f118842608f754c7692ed9a99365ffbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf906e84348d4aa51935cd70346775c0e3c9a9b3ddfe5aee64ead78f80f21ac5"
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
