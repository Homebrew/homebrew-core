class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.65/docker-machine-v0.16.2-gitlab.65.tar.bz2"
  version "0.16.2-gitlab.65"
  sha256 "85008bfa9427dfbb6efde3717ff4c18fe701ee5c88057c33dc2863b049b1a378"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6685f4d109e09f8cdb16fdfb64dd922cadf4854053eeccb54e446181a4b87ebe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6685f4d109e09f8cdb16fdfb64dd922cadf4854053eeccb54e446181a4b87ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6685f4d109e09f8cdb16fdfb64dd922cadf4854053eeccb54e446181a4b87ebe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "890d4e13192c30e6cfeb906e1fa18003efdf60528ed197aa764be337f90debe6"
    sha256 cellar: :any,                 x86_64_linux:      "f9bd90e63d693629e3023fa65adf66ee318e74cde4467945e45c553caf162a98"
  end

  # After Docker ended support for original docker-machine[^1], we have used
  # GitLab-maintained fork. However, the fork is now officially deprecated[^2]
  # and scheduled for removal in GitLab 20.0 (May 2027)
  #
  # [^1]: https://docs.docker.com/retired/#docker-machine
  # [^2]: https://docs.gitlab.com/runner/executors/docker_machine/
  disable! date: "2027-06-30", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/docker-machine"

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  service do
    run [opt_bin/"docker-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-machine --version")
  end
end
