class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-18T18-09-59Z",
      revision: "829ecb20867dae80a75f9ca8e1e89d7caa892bac"
  version "20210918180959"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7192edadb49a8c61084385c25cf83241f4264907b95baa0701764421c0ac136c"
    sha256 cellar: :any_skip_relocation, big_sur:       "9638804a872196ec6ea544201429af94c29e77f1975a985ce7c6ce3ce7bc6f2f"
    sha256 cellar: :any_skip_relocation, catalina:      "a6563ff55345bb900b7dc40b5dbb7a1c83905bba2ae73ffb9a1d711811106bc0"
    sha256 cellar: :any_skip_relocation, mojave:        "dd84ec77eecd80b0ffb72a63025acf87046beb27865236f63d8d6bf9ff1451ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20da8e49da90b88f9d164d3d1c5e02abbd7033f6866fafde2c45b52e9ab0134a"
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
