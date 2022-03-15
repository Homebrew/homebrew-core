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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309248824d4dc050d56a1b7499b92c61a4567bd13f28e3a35d490de871e59985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c123a1c77d625fa800cc496e6391ef522ba035b71d15b02e87e13963cb4f118c"
    sha256 cellar: :any_skip_relocation, monterey:       "f835316424099c6ec60238592113433eb3a441315b63477a31c95436b7a4ac7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b65be146d21e0f65eb9cc176240e30df96fe0f1b515674786c104ef2160e4b2f"
    sha256 cellar: :any_skip_relocation, catalina:       "bdf9de9351ef19e887df4cf9810a3612ea28fadbb5af72d66975c2759246181a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45dd6772466f5efea7308fb53550a23d6591f57fc766cf52988b9a445abb23d2"
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
