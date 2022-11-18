class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-11-17T21-20-39Z",
      revision: "2770f13a73c5e98ae1a0665c76cf099f5f578a13"
  version "20221117212039"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f19c281d930b6bd08dd3f746e157b9a2285b04f87a781de5fa02c1eb69eb49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea876d20e43efbb15ce16a90eb6402c1020210fd8cd3cc54f9c5eb5045c8c1c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9e288db2106c94bb99037720eb54b74ed51f2e92f56473a3bd78573b6ddcce0"
    sha256 cellar: :any_skip_relocation, ventura:        "df1bc31273b680dc29170f3faab7f9eec39d1f517162b2a333f415ff0491f142"
    sha256 cellar: :any_skip_relocation, monterey:       "844e5cf1316570cbe29b03a5136d0d06b2494273a83343d964608b35b87411ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "8df3b85803475af446b5288b17f0e8e552be5bfbc8c8682b8b1ab69ebdbe95bc"
    sha256 cellar: :any_skip_relocation, catalina:       "3afd7c27d11ae73a9ac427d4316dff61b9b5d219b962d9a2d34cea5ad8c28c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4280d2d7566a720d23900c26051d0dc4d567243c56c217f34fa492cbd8d10bd"
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
