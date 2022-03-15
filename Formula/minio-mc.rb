class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-03-13T22-34-00Z",
      revision: "0f31ce23b9b26885a017741e99d8848b2974cce7"
  version "20220313223400"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cb7fbe61e6ae80aada31d7751e43a79fc73d696c6e3642942765acee1ab8981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f54fb8c3e3acde07d83c483317d559d60ccbeedc38d43f0b68f6774e04662efd"
    sha256 cellar: :any_skip_relocation, monterey:       "985b6f3675fcae1b3c5c11adcd993d6b9b7e32cbe207126406adcda20adcbb96"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e9b8994ca03caefd105fab723afe25ca90a0dd79c25df5596ef1304de8963b"
    sha256 cellar: :any_skip_relocation, catalina:       "2e46a86610ae9d087a36a22c7bfbd9480163dcd63521b810ab5a94fd076a4f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efffcd0ec3c92b32b6299128a4ce010a48ad1568b8c3a2ece7e369bda47396b0"
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
