class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-06-10T22-29-12Z",
      revision: "7a6a43046c01639c80f09d97d8427c5b5a1f116c"
  version "20220610222912"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a93e7153a596d9e168f004b83362810fbade4d674e11ecc82fc3710028cb0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc0913d4da324d9f215cb7e2c3ca1c2df09d13a6a5a99e17c226b26139363c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e56107b9163b3e97eef318cf7a39c5a244c0758e39240169bcd0a8960c045f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e96c363b50ec64c3009d74aab4082bb12cf4c84bf6ed44c9dd936c5640a155b"
    sha256 cellar: :any_skip_relocation, catalina:       "52bac79bee5da181eb5bef59a1034150dc980b0ec4794626080474a189088c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae655a706364e054abd55e8b5e2703eb482676192e242f47d0b24b0b8e3eff24"
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
