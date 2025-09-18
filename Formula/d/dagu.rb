class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "b3017501722d006c5678d48bfa15b4f2dcd5de57e4a6dba7b8a2c078945504f6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4efa7c713b1853ffa32da0c53222f3b5546a6058b0f103f91fee37b310b31771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf3d4223c36405288b29dd4fe4635733d0f01b79fd335806f5b999292dcb0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ae5178725c73d5e38e519c52f999c7f29fdcc7b9db8a8fb0210e5b670a10284"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55269ed48907dea8a46cb3727a3f6c2136bfd08391af24e0c7a04fab61a77e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "6591125ba74b097d2a0aca4f079f24eb3a8348c0664b00fc0b3753cd82fb22c0"
    sha256 cellar: :any_skip_relocation, ventura:       "220e6db51725d7ab78e1d2d86ab39307018c31b33d0916d3d9c059c480111472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bcba79801e39e0e96f3798c866750715332c9c6c5cfb876de3b5ec2e6db29cb"
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
