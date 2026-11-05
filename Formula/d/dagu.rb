class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.7.tar.gz"
  sha256 "d89df882fbcd14bddd04ade71959fc8db2fc97b095454ddc419480ed57fb0d23"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23ce6c702b5c256f2194b8cc7cf42f32a98652016d80f946a1af2475ae9a2e7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "622871195f1ae556619fd3231b4001df12d96ed694c22d0fb77188cb2eafcf02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ded57fecfe5f9111427fcea5394af6e30168372228261a2efb732209a787db77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14c5973bdd147c8ed54a254099e9c3d2d76a266ea1bc8801bfed26831d8cdc05"
    sha256 cellar: :any,                 x86_64_linux:      "a157636ff6562dd97e5858561651fe8078ac7779ba35932f43ee9c0abc9daaa9"
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
