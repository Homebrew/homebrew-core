class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-06-26T18-51-48Z",
      revision: "40ee1a4ed60f3b2f618c4eef282ff8b29ace7045"
  version "20220626185148"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a3d75c2698cf139ee28d1384e6a6151d1d924467d15c48b59924109bbcf6d2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec539f93de275a22e73f9e1a9ad232802369134f241e1184938206d673ef7bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "f73a0b4a702f861cbcc1873b1872f97d5e9b512242892d4509336b8a1f08cb62"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6248235201061d864d3bd47c64c52b237eac29620c81aa1e97db5125e5b57c7"
    sha256 cellar: :any_skip_relocation, catalina:       "e2ff0583d9862a5dab22cd6eb139ebd2ef16c671cd589e62ed5822fdf51a541a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7928c695e1d694715790648a0f70318d9efe9f0e040ad427e0d14a41941d00f"
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
