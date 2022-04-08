class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-04-07T21-43-27Z",
      revision: "3f0953f9f47326f9554c5067b39cd39ab82f30a3"
  version "20220407214327"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8321177ab7efe57835aa33139a8a2e2871e9515b84e7b7604516b77bb22808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d450f7070a297a52ebd4227ffc6ff17126cc786a77c069749298c99b449073a3"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdb457f18088335ca75d06672ee8d66fcc7b61df4d26d772ca1b8f8027f330f"
    sha256 cellar: :any_skip_relocation, big_sur:        "247175d87f56e1d3d3652adda82df97319e23edc1895089a530cfaa723672409"
    sha256 cellar: :any_skip_relocation, catalina:       "37bebc0ddc7e7869ab40d07fc4c4fc847a1fb8f5cbcb151ac846d06159a1db67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "563025011e0bf512c521612eb7ccca53c6ef5bc45ff8383be06aeec8dac0d166"
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
