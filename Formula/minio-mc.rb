class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-01-05T23-52-51Z",
      revision: "0373840f4261c59e5c836cff0148f9b228e3bceb"
  version "20220105235251"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4050e1a55f402589003dc2c11075b4f04248c5bf7ed9a8cdb3377f4f9df4b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb0dd434adff63ac869dd9aedd53f895e8712b14ac56ef142125582f14ac1ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "6548bb74dbc1990d54bf0c84ee418f1289a8788fe95cbab4ff3f0dd5c9450c84"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2e38201819db6b17922ab3f9f8ab041789295993d4a6520fd96cc3409c3607"
    sha256 cellar: :any_skip_relocation, catalina:       "c698025388882d6757c5cc1de84254d0d43220bca11e4f89c05a2d06b5c6e722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7667f97a986e7ca87b5d93127ebf86f94f4874cf5ac23610e4a79773817857"
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
