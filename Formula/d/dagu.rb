class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "9042b06e74b755aa1da81c5128f9655fc9ee68e9b58cd9dc7f9a5ee65a8ef4c2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1ad03376ee02276f69a6603f7fb3680b6d4c9ab4d9e071283e5971ca07242f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8bd715aea162372aef017ec7acad3617f7370bcad40521131072e58ba4453c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b32f0148e12e52b85b0bf6fdd0d7d4ab1b5da2eb68efda07f504e7da0b40e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e5f2c09965848fe64f15bdbe6eca83840b502918ab174ef85b195b067cf40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af47026164a47cffd0c4ea7e4a62ba972ad5222eb707598d1a9fa8aab48e14a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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
    assert_match "The DAG completed successfully", shell_output
  end
end
