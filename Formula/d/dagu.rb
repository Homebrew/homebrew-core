class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.12.tar.gz"
  sha256 "79ec1a53da0678a46a8e5081479374e848abe140053c2416ba308b433f718c9d"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a2d807460dc7b0de10447e071a7b3143923dda672a3e4605254d027ec10078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435425d7e57ca10d397d72c3761c0d84d4a8ae486ae57f2f4e3b485124ae8cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c924a06ce0b15625f6a70cb92decaf4f4db6625e2731f4d6cfec6d9af529379"
    sha256 cellar: :any_skip_relocation, sonoma:        "3878f13e3480fb19866c7bb9ea1a0921183428446bbdc3caa12e9509c9c70be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1caaf9722f37187cfd2ce410f6bb63379be5279fbf9cf842017186d544c7f24f"
    sha256 cellar: :any,                 x86_64_linux:  "4f6f8c380b3fc448bd9eb45a45f9087fbbc276ac082565e7a1bdba94b842cf74"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
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
