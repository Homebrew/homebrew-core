class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "5e5ca8614c176b0d8d97aa88320472b8505db628677b624fe9457ed3f755d524"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ac8043d7f96e76361eaa1e108352b4d24bbb8406d363328a528dd0263eed79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c421aaf79ee51a7944e263a897e79e0e4bd7d339368d04ec624a2feae18234c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c68785dddc6c440f6d999157d3d0550054e702e4eff416246a62b84bdad7126d"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e5d76a20ff6e9d4c139637d6ba93cee3aafe5cf6f182b22e4e48a8507059bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac15577c0aa0d3da36b79b1e03dcdf70f2fdad4bedae8e7cc9f935d8cbcc04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b9f64ac08088c3d949a89661dca4df94a8ffcb9216e1fb1e2107ae118480a7"
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
