class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.9.0",
      revision: "656c1943068d1238fd4de226c784c2d89bac57ba"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b780a3ed32d1882e714585cf458ae46b914a65c7d69c4cbdc8aa0f0de6cf3d4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35a89af6d49747e37f006d82950379efc77c462d6f54c49f7164edb338afac9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa498cb85c86f35490f597be90ffbd78775f7f2a0d7de5c4f96de17167152eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b75c74faf3ff44c61487f46ad654ad066a0e68aaab624758f8db0a19d9f5d1f8"
    sha256 cellar: :any_skip_relocation, ventura:        "59419287cd1c074f64526303a148ed3b6b1fd54a806d5fad7054730773efb5a3"
    sha256 cellar: :any_skip_relocation, monterey:       "62e91b0f7baecfd469edbca962378bb6e294e239a6bf2d357d73658a6608504f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20082cc76c3ec1d2817affec74243b6eb3a4b207cc8b46b74c6495823ee10d34"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
