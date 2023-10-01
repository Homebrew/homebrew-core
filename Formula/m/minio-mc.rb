class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-22T05-07-46Z",
      revision: "ae05d451739bb8cd35952f7cac0b11f60407cd52"
  version "20230922050746"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a445cc5df083ad77bebab858c14cd41f9df0d0c10ee86e98e8288d6cf67817f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "130740e457e6f55bad02fb24ee26031f913d816fc9bdc0cf99fd55ba44b16014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f58423f583fe9cfdb569bd41d43e17f5667a3d3d0483a0203f8c7885f036f03"
    sha256 cellar: :any_skip_relocation, ventura:        "424757852637de9bff333304253e91acaea0136d3ce41c3d9365ef67473babe1"
    sha256 cellar: :any_skip_relocation, monterey:       "8f22729d6a5f14892cdf3fce96ec9ab3c9d3ce623b27ec30bc320bed16c1f67f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dc132a1871afe2544d2b34084ac87c77ac5ca964469f8d823195ab4f28ee3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a48bc22d5915a0adcf25f33f170ee919b2cb4a9eea7f27c1a1ba1447b0be84"
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
