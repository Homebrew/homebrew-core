class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "30d53c1c10e7a4cae7c4390bc7c843d6fe258e114ece11eafb8050fea62c763b"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7430b3baa19cc7b3f563dabc7d485042fe36c762b298d4c4eb6977896102e136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ceaa38646e4f127b7a653662f415a8641c4772ee336288d4642c3d49695115b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f23af5945b9beb7690a1259fb11df1f5f3568f9da56ef495fa917f116fda4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbda100f4fe0099784183e4dbd5bad740be4cd0066b9b16febb17eecfd90f338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1644f14a03fcf610430f47990e2c1d5e0e9d24c25f0b9d894dd62e14da2c1901"
    sha256 cellar: :any,                 x86_64_linux:  "7f9aeee6e84b733179c49be45ba49cadfc860a6d6d020cee4b666d907e181c1c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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
