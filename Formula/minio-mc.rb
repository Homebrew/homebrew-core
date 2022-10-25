class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-22T03-39-29Z",
      revision: "88796ea618092bb27368c00e2b387857945357fb"
  version "20221022033929"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76b2254e2f5cc6994ef066a060fc9ce652adc56fc75c95a077b6b0f1d7084318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e65b08503b63ee50c830ae159dc2ce015d279a40102107e1dfb15752a58db85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f49ee6a7acad9e21c6be43251dab0cb3c1059f7a478d05ccfac8e9664b4d24a"
    sha256 cellar: :any_skip_relocation, monterey:       "6111e7e52772b24fb071a69bda1e0c6936fe037db12421cc98f2d15b315a5171"
    sha256 cellar: :any_skip_relocation, big_sur:        "6753d37a88e4461fce4c73a9814b4f74dce0f701737570de805a749d6f6f6928"
    sha256 cellar: :any_skip_relocation, catalina:       "a6856d1059c1070b13997eb36d2cd8a4f1e2f7eafdec0870e7df21334ec764f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce3aa03e1ec74100b896b9d44c2571dc6354cb5a94df4db4b800d8380c408ce"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
