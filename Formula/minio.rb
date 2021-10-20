class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-13T00-23-17Z",
      revision: "129f41cee9e061a2b311f82ddfbf7c0bb4263926"
  version "20211013002317"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "259145cd4bc8bd786dc8039dd5ea8eea2a03c82a08c04a49798aa0e5c50d17a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d3675b1cdaf0f86f1c228cf452f006d890e679a5c4f7efc0c8dbd528f88ea0b"
    sha256 cellar: :any_skip_relocation, catalina:      "65281097a8dac7a9408d4084b4b76a7dc8a537793ed1cb4e87035c1970e18362"
    sha256 cellar: :any_skip_relocation, mojave:        "554de231c396a39cf36ffbe7f25af384b93f8d660b80435206b7582b748dc4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e80c7590f82c2fd5eee9c396c65f8256fee1c3b37638e5ada40b112b9afb4d4"
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

      system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
