class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-04-12T02-21-51Z",
      revision: "1843717c57fb87612469b7610344a7d49d97a497"
  version "20230412022151"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a30332523d72da33a7f89ea7c8b89c0dcc0ba465fc00bbaad77943f3f75de3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9439e3d4d42dbc019d98fe9d4199f680e3f8f1c07839bb4b898cfd2049708a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "494c41b49b548b8347ff315b8c0219ef2190e5aba3cc99bc2cc549a6782359d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ab209d13a88d9dc4d8c11eeffc0075bd3a8295a5fa45650921b5d2bd96c88e52"
    sha256 cellar: :any_skip_relocation, monterey:       "83a55ca9d006f44123b432c24059fd3835048d722fadaa9877a0d340125f135f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b8c1eb17b18ce1743f3fbded746b8859c638a3f1de72465d05cfa83891f6dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a6e8df82cc3c3b43de32fbbd5baa1667cd854e3f793b92d365cde2a16b6a54"
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
