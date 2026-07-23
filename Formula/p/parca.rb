class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  stable do
    url "https://github.com/parca-dev/parca/archive/refs/tags/v0.28.0.tar.gz"
    sha256 "1b19d722b88db0e6a31aeef1b8846156a3f38568cf1af059a287ffbb608599c8"

    # Backport migration to pnpm 11
    patch do
      url "https://github.com/parca-dev/parca/commit/cce673deb34ae93cdeeba37f5391c077e1a6e53c.patch?full_index=1"
      sha256 "b8b3392ea97bcffa4ec2d178acc9eee24092eae0638d1b8b6391867c1b654a46"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d21f675c0cca9a7e326dd62a6911944c5e2ddf6fe79632b8f64261b7da8fe56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e7d8fdff5314eaf0c69538db05b8c1359ddf32c3973da2e250751a1c2848ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4339e9f89bff3817e65ba94a2a32f7d79c4cb7cfc03c7530b0a2e67e49146143"
    sha256 cellar: :any_skip_relocation, sonoma:        "adfe5aef4131d721cc19299c8c14344fcfe61ecd9aa244cbea7d03fda44dae30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe22b4f736e5c788166bde18c3b19418024b8b77188a422836f431cd8f5d382e"
    sha256 cellar: :any,                 x86_64_linux:  "e9ad672a3c90fff570752744eed9442ef58f8560f938fb562be17a35d5a50abc"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/parca"
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
