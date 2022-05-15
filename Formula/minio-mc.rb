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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a571683436acd759ae20dcd5fd252b1e65fb88d507c34a223efaff5973a5e50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb124fad308e417e728f119c5d912475077e8595ab96726821adfd7a52a73f14"
    sha256 cellar: :any_skip_relocation, monterey:       "d48369759997a3ae5b2705b243aeef482cf8f464b4f6294a5d7aa90c285ef382"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06b724fc7db7e9ce1928475621aaffab1ee6a70da0493b2f14446c29de830eb"
    sha256 cellar: :any_skip_relocation, catalina:       "b168a6ab8cf81cb9c4e823b6c51584700ce798e261b499477f87bf8735e9f084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f52e34511a588536b1cf6568cf0800c03aadc4a93550c72340227b96a2629c"
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
