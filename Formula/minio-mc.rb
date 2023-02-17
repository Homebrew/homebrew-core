class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-02-16T19-20-11Z",
      revision: "54e2edd1be94831eab8dc62b4d0b048825ff5cc3"
  version "20230216192011"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4d938ce3d1e847c92fe8932a141aee553be01a8e1efe0e91cffd90493206a95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a95e38d700fdb57e4459e315dcf657f01fdeb18df92c5cdb6c92c8ecd68c4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fd88aa776d2a76b2eafc4c210142710d8f75255dc13e60cbd4ecc20487f43e9"
    sha256 cellar: :any_skip_relocation, ventura:        "0dfb7ee5b94cce81ae95c1514773392f0a05ad5868a2a05200082e88cdc323c5"
    sha256 cellar: :any_skip_relocation, monterey:       "11326d66102aa0c07fb1389c3c5c891b186a06f1a593de706cf682396ab2fb5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d134068ee6f70ce9d4f48e34c69c56a6dd98897da5c68c5e6bed58d0fc9f5cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a182d4fd3ea9ce8a557d6e80d0718ed69e2aa2bcc5c3bba37c0751817fd692d3"
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
