class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "59817e7bde54296d15ba584b9ca5db84f7008d6a38bf077d370dace81ce58e86"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90017b31016e79ad90a1efde46cebb7d74b90de10ca99d6c1dd641e46b67644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ff4043891092f2de526f539e704897417d9166d24ba41f5ca70274eca49f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5454b188b18435238a9697776a941c41dd71165076f539b927188340da66a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "2492b93b7b805f9534a5736398239c0c14d6445c34abb0b1c88accae8898b106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372cfdf1e8041049e53f21ad29abada89c68973baa0033dc1c0aba52449face7"
    sha256 cellar: :any,                 x86_64_linux:  "7a50513aa2b8a24dc3efa2c64b2d10240be6d65b99481a480414442e4f78649f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
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
