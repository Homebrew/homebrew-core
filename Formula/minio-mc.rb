class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-04-26T18-00-22Z",
      revision: "276e1db70d7bb495025b414f509b63f88c74c634"
  version "20220426180022"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8e43658dbe128b3072b622c910c86d305784a502c169e084a4a12590390190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af138076482d3ce72fa4ceb11c163afe5e239a863e1bb85ff70edbb08fc604a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f64c49d6b95ec9d55c7545c76a148def8c9b132fdaf810885d48a184f3a323b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1c9349caaa76cc4fe173d11486cc4a4178113b0a3005ede4bd8c94631a7e51"
    sha256 cellar: :any_skip_relocation, catalina:       "701605d28d6433c65cbe9e776b6528edd73139d1a7e359fc5013f9ad182ff14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5701fed681b3a876fb5f38a5b0eecd584af217ec157c62a312285122803e11ab"
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
