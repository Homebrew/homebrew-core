class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.10.tar.gz"
  sha256 "a32f1b00ba808d906648e806f9d1e1102d4e7118230dbbd3ece5c7511b3ae84f"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9a8371117343ad5dad1dadf33befe46d71b1f5a400d34d259a31c92509f1c52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a8371117343ad5dad1dadf33befe46d71b1f5a400d34d259a31c92509f1c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a8371117343ad5dad1dadf33befe46d71b1f5a400d34d259a31c92509f1c52"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7945efad0e489a138f84c3896ee384dbe8b8b5630b0704b70c82adfbbf80a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa6fbf3378c1d774334ec67707f1bfe0e731909443f985613d2f61a75a75665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69045eeba0272760f9783cca577b96672741e734777125bed68aaa23174afc0"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
