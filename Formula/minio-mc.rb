class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-02-23T03-15-59Z",
      revision: "620455a22ce33528f8e2e39c4b6216413f9ff368"
  version "20220223031559"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61c1b82fec28c7c810c0f4290af083b45d956e798bdb112b707554d1b1c0b12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a4698bcb5e25cfb28a6f54f5ad9233b30dcfd98f1376158af7c70edad4ecfb"
    sha256 cellar: :any_skip_relocation, monterey:       "4747a6686295fae5c8c637711e0482d414355a38902f9a4c55e39b4101265e16"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6cd9eeebab727680d34f79fc5b63c8c83e1d7afe254d593beed737eb8b78a3"
    sha256 cellar: :any_skip_relocation, catalina:       "3b1c39d5ab2c35aa109541632a4722039554afede2a61353481475e58ed0144d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071a770b16f33eb8eed7da96e83ed3066f36adbd7089cf6afbec01058ecaefbb"
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
