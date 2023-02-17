class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-02-17T17-52-43Z",
      revision: "84bb7d05a998a096b96acd68ea94053d28a87eb3"
  version "20230217175243"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec63ebd543e39fc878d4ca7add3e15d6835b9df94806b1726da374f15bb007b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e533eb14d25d9445ac5f53afdb1624f7ee93a8c121a5c0bce008bf1c748f67f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15025eed53cb73d5cf809db3c730acb58c0661f707b748855beafb3c9692b892"
    sha256 cellar: :any_skip_relocation, ventura:        "78cc087177d4c9822de63563d4849730f925e5bdee5aa382c111ecf32495d808"
    sha256 cellar: :any_skip_relocation, monterey:       "3eea96c29f4303a1a42baebde12b2771111c1a033e36cfb406499b29caa422e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5dd56387f71709e5f1f87890078a99d2bf48cb2373bdd5e4062a54e80722e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108ab8b4558e1b549188661c97e8db762a3e6f85a4bece913176bed4fba692da"
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
  end
end
