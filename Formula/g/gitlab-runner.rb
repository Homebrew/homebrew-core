class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.3.0",
      revision: "071ba93d4da2aa7cecc94f42fd9ad19ab9550066"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d69b6f102820cd821f70ac46742eb119ea708fa891b2296e6ae6692949959975"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd3127fd5fd6149142bbab7ebec6fa758f7d9e52c1ba38eb83b6d4d207680a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2f66ec3c9c575ee15c2ad4d2132cea08c85e95fa75dc1071711eb076457288"
    sha256 cellar: :any_skip_relocation, sonoma:         "30489aac7889872171d2f7dedd49e82bf81a32b5923d09716503270a58855bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "1c6738f86cf9ad0f01b7354d7a0660a92e180c208026bc6d405dd652e1b7e4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ec815d22473b146d2c7445ae6adbf082a99aa34e545f32c332e1a403fb2d679a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a1a4b88867f84c4c4fcac14daa199e59a6d9e557a40099e944f0c40a911615"
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
