class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-11-16T20-37-36Z",
      revision: "d0c62eb584e57387fa62a8b6637b077aa3b2717d"
  version "20211116203736"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50394babe372d7ceca71efd90a8a53281f7a6d9b1c833067ce1b36ffb1e3c75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f49b6280e7e5c36a7004ec44d75c702ddc93f765354d4ccd8dba5534536e171"
    sha256 cellar: :any_skip_relocation, monterey:       "5df688d10cadaa235e8c2de92108205bcfecf42279ca2b84ed7bec0e0402cec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fca1e25a1e867e6a9df081cc330a59e06f2b24ab08e481ee9fc2c51f421b6277"
    sha256 cellar: :any_skip_relocation, catalina:       "66ad2b6e1a7a262bd910a16ec2e81044fc7adc44bf2f5dd285bcbb51f58597e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df017330db97f94560392a5f61eceb33daee3277fba20d40e3a32718b085089"
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
