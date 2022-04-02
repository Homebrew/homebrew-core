class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-01T03-41-39Z",
      revision: "892a2040136da86183151b88e3ab1f769dfe207c"
  version "20220401034139"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f45dcf0c0e6d7a6b0d96cf4a59030fb3f62e2ef71aa82d1ca1cee0746f5fd0b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eae155dc2fd4e6f950fdfc2b4c62546d6223df639cf3e78fe9816e84db099f36"
    sha256 cellar: :any_skip_relocation, monterey:       "eb92d9c432d296c99488f13f00ab658809fcac7b4c281bcad5a725b4e7fbb44f"
    sha256 cellar: :any_skip_relocation, big_sur:        "97226bb74fde51506649c8f340418341a75926cfaecdbebb7df07d9e0a36a234"
    sha256 cellar: :any_skip_relocation, catalina:       "ab7ed093be504cbbba4b054e4a97edf9404107822a7d8eec47116d68d4597009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5023ad03bce2501c07bdf5ea890cf1839e0a7cecf0e353bc69c4ef7b8c68ef2"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
