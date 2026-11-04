class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.4.tar.gz"
  sha256 "13720fb696a2ca70857e21d52bde6a780ae5abc7b3962702740ad80939341e6a"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34c8a285c2098f7398a48c0e6c18198ac4772b919e726f6eda8da6744c33570e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cee07b5fea460d7ab65d405298b65c3e5a4a64a76553d63b2bb992f3cdfaf6b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa0a21446eae70b8d72526a0a0eb6ad5f7686d141d58521215b3ace3a9748a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f2e00bec81d1297b0c976209ef19841cd25565eaa5eb8dfbf75453ebef07607"
    sha256 cellar: :any,                 x86_64_linux:      "419d3b65c371c81717d824b0029af8791a976b43c3aee1b688a2c903f73775e1"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
