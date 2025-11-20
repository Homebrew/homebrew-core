class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.7.tar.gz"
  sha256 "3453914e7cc9d3362cbb325e7af3effc5960e17549e4af9c14d8911596a2dee1"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b824fa3e629c2cde203550c505518b7f0564dcefbb2fb213e85b2d4344d587f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8837a5c79689b338af8d385a1ee520b584ff75af6edd210b23e967c8f52ad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fa39b1636c1171cf8041409f412801036f61d851910773ae2b89cd974def47"
    sha256 cellar: :any_skip_relocation, sonoma:        "014633adfa64eb8de71942c93ce7a008463db63dda74ea42573cdf84b467f238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1889497219e566da13120c72d2a66e4097e5e208b06ff412f29b0c98cc416a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb360e311132551081301e350758225fc473d77bd18a4735bc75acc0ec47bb0"
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
