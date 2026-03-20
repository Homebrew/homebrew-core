class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.10.0",
      revision: "ac71f4d8afb8063ac1cfdd8a8a6cb7b91bbb515c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e64a3c822632061229f1a4180f5ae94db2e2a11da5547eae32da9e96f27d022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1833da2db56ed35d51e3120510fc9a84777238417a4fb6454f6746652b3656a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461b223472af1dcbe6c1789d618689df3ac430abcfea3ca2f8278baac219766a"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d4430c607fb4a4e98f18258bca7b5934414ad7d6d256ed90a815a6e9cbb44b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb1405f95e37cbcdb412ed313e62600003acdfa5f64854f0d83c628213375a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb26e49a3faf353acbc8817d061d90ef40975351f9e1a77da8b736fcc3a76eb"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -s -w
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
