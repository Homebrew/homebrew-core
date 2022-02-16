class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-02-16T05-54-01Z",
      revision: "220f7c217a8ff5067195fdee6c76d011cb099740"
  version "20220216055401"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48998303fbf91460668c0bf2a1be16d7bcdf0c03a2de92486422f10ed941f159"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6ec48d452c42f1f85ddf98da59d4dbbc4bdb970770956c4b43b22c85b6f08bb"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7586a96fe4033ef1aa2d0d6e23b4d0b6d613f3db2cc472fe6f206a4522fea5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf09b2a092217cf71b6336a2f3f0d56cbef58c37abba826024e5c2f117ae4c18"
    sha256 cellar: :any_skip_relocation, catalina:       "16eda253c7f54ef9743ee08c0088194d89480473ffb49252db1e71a3a80a0683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7757718ba05cffeed94ab6c9993591ee080791aa570f244de6625ca049c11b9"
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
