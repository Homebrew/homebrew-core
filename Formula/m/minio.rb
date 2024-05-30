class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-05-28T17-19-04Z",
      revision: "f79a4ef4d0dc3e6562cad0d1d1db674bc8c75531"
  version "20240528171904"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04f3389040df761548cf466c7aadcf53d85ccaf56bee88e398e48f6964e3ceea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b933cc6ba7619a5b425e2196dfb6f087a59d770f80061b4d6fc0bbacf59378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba929d41693370efaedb62f7b7a8d238b07511b7cf7d2dede6338869a98e0181"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c48ba7b6eae297ce4d44ea9d29fe00471f390be98d8ec2f12a126f2ecd82a6"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e8918a9cfe39a3ea5d0b1f7c1f302f74b675c3aa16cc185af169a8b3f15b52"
    sha256 cellar: :any_skip_relocation, monterey:       "42b9328facacec885d62ceab16d62410118313807dd359f484cf5ff5d27d52ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da4840db50a9fae4f4829f0eb01f9517965fdeeba65f8f4dbdd8595f1031bde"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
