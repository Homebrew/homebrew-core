class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://www.cloudwego.io"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.9.8.tar.gz"
  sha256 "1afe64cad65a12cb717521427371ce092fbefaf4c180669e8248f1926f71ec9f"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69c4f17bd9afe8ad207221f96a5188911ad1b243ee6b7a8823a02ad260d239df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69c4f17bd9afe8ad207221f96a5188911ad1b243ee6b7a8823a02ad260d239df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69c4f17bd9afe8ad207221f96a5188911ad1b243ee6b7a8823a02ad260d239df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e39551f9ecadb14576f4c6a67b9b81a20d952897a63efe41adcb9bb9cce21be"
    sha256 cellar: :any,                 x86_64_linux:      "211572493a980213ae0d6c369f40f0e8df969479261f38c6f6af8c54ab3e0c56"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cmd/hz"
  end

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args
    end
    bin.install_symlink bin/"hz" => "thrift-gen-hertz"
    bin.install_symlink bin/"hz" => "protoc-gen-hertz"
  end

  test do
    ENV["GOPATH"] = testpath

    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system bin/"hz", "new", "--mod=test"
    assert_path_exists testpath/"main.go"
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
