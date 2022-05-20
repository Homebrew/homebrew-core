class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-05-09T04-08-26Z",
      revision: "b5a0640899f8f8653bcacd19791c92ca22066ba3"
  version "20220509040826"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0991ad7eaab3cec47e957c7a939f2c26990674ef649b66a191748aff99dae1ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c76967afad061ded41cab577d909d3db80ed96c4836f892e9eb0801512a245d"
    sha256 cellar: :any_skip_relocation, monterey:       "8a76996af3d0cab2d042a40a6a8f1e01301da47932d240b9b470cb936e329a35"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a08bb082d221d87805e4da92537d7ea2152a64b0e7b80758b7682576befb00"
    sha256 cellar: :any_skip_relocation, catalina:       "54fbeb9c2babdd36da0fc8cd5a0c808559e433c01c1ff482e604d66d34c9f358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c53580126dde1897d0a243bc7550a8ac78360b23cfa2e31558a15ca7fd82f93"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
