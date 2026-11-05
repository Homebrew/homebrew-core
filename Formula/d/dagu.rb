class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.8.tar.gz"
  sha256 "58b407b9693e06ee8ec4cd59895090d39cb283523c072d579ba267b138eb6b26"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3007baf2806ba4a22ec860027de3a042d032719389c483f81a46a3e81188991"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "773e234f910f58190bb2ca414e8bf376dc1729f273dca799713180ed7b6019a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78033e3c5406aa1befaff4c80970195493a5d86bb98415f5a5ddab78cdd653df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce332f68f2b408d900921667c78b4741ef028ae570e26bfb762c77bbee11cabe"
    sha256 cellar: :any,                 x86_64_linux:      "13ac451f7cc154be5627e5e726308bcb73e35832ebac86244fc13917be26dda8"
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
