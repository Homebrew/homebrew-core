class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-02-07T09-25-34Z",
      revision: "dabc6c598e5e1fc6579140adc636beb15164d984"
  version "20220207092534"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29debf82c16686d3ba228d53b013c9a7c6de975bddb3fc30185c370cf7ea0eac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdbdb2369f6ea3746061ddd8565af901449eb48eb0c2c7ae8be119fb2805b99f"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8cf617df9c5f0606d949736e7336533554dff6aa72d1fa9a46271c1b91d1ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef1ef0de5aa5d013e2667a9609cf2be0b7aeb202969652fb9e8addf63463140a"
    sha256 cellar: :any_skip_relocation, catalina:       "f67c306b3d6566cd4c6f2eb65436e3477778c2fa436d8525ea993a1301769beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0211eae2fceba339b3a977e3a71c38e4584d2f9f918d60c80d67f92a8de3f3"
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
