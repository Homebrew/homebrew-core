class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "61ca1b92fe77547542c0b4908ad8f295ddcde409ce48e5133dbfefd468d44bd7"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c8f295d5bc66b0c59cebe9bfe99d0567cc9532e40928c7ccc736411bd3df300"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f759950fd76d892f53cecd7f7008e9186044e989e79c1af9257979d7bd88c316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98bf746a9970555a930d851479f13fe36727c3d1ff709b3ec8426b5f8072645f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd764c3438e06ac41ebc183d051102fa9147cd2faf83329640cfd3e53b5d22fe"
    sha256 cellar: :any,                 x86_64_linux:      "294f63b03cc9d7b03450c24da19475935ab7256e1e1c2e8841df0173033fa17b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/parca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parca --version")

    # server config, https://raw.githubusercontent.com/parca-dev/parca/cbfa19e032ee51fccd6ca9a5842129faeb27c106/parca.yaml
    (testpath/"parca.yaml").write <<~YAML
      object_storage:
        bucket:
          type: "FILESYSTEM"
          config:
            directory: "./data"
    YAML

    output_log = testpath/"output.log"
    pid = spawn bin/"parca", "--config-path=parca.yaml", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "starting server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
