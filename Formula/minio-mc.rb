class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-12-16T23-38-39Z",
      revision: "7bd5c343f77fc30bb37ed6700c2314827e8e682f"
  version "20211216233839"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a7afe642ebd25815b90e96bf72d4be2990bcadbbe13cf5d0d5c33cc52f9e0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a8d8994bcce0f5bafb7410ca398dce73cd40fc706ce5fec81bc10a27be2539"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4119c6a8e78b0c40462f830145b9b0856a47e4f8cdc484272b547510b96fbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c523a78ead1fa6e5e084163e8e53ee06aa5204679d9f29ed02853cc6a0ac020e"
    sha256 cellar: :any_skip_relocation, catalina:       "b997cb47fa6e4809290cf6eaed91e183a26af6cf6e90298858ad68a91690c713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f0c7696c5cfd249f2e6fed8bba7b566c79ebf273895f73994cbf07a497230c"
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
