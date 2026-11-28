class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "4b9677f50307484d4d828b4b25dab5b7953d68dc25e4342e45d79d0021834be3"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    manifest_sha256 "99d4eb7cc653ca67d33654801ac9027d8264d2f4a9e392afaa88eb5677163ca8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e5154436729b000fbc66e7d456150de1fcffb62a7f0c0b93b788b0bb52d3518"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "511167cf2692c6f2019e64ba810c6d88326cefda05654543f68436a51eafd7a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12b847c86e523056f7bdbeafc998d5d645dddbfa810b675f638ad6873ede9582"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e647a58735492c5c1eac24fb65f16baa3b5999b47355ecc7e6fd570f0c7de87b"
    sha256 cellar: :any,                 x86_64_linux:      "1475c31273a17df71fb820eaf7605b2311161707d9bdb179bbc618f747db0343"
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
