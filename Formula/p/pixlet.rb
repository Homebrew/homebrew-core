class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "d24f93517d0c0887bc657b82aace61c84f2c836b4ea5eacfb3866cdd6fc2a0f6"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5413857b8732cae316b89181f22b75df5341e2ce40df184e234d5cbfd3de1b9e"
    sha256 cellar: :any, arm64_tahoe:       "afc1aa3d22fff1a1e1ad638acc08a57a2c18da33949e6173e98d264003c3ceb1"
    sha256 cellar: :any, arm64_sequoia:     "c68d3e1844dd6f5fe8e693dcdce302e0019fc365e7a34b030f62d31fddfdb6eb"
    sha256 cellar: :any, arm64_linux:       "93240b1c8cf9365381ad89afd8a95d274e7442df9fb28c9083bf957bacb200d4"
    sha256 cellar: :any, x86_64_linux:      "2587ed6ac1fdfbc77e487285c5b43b7e36d93575c1b90e07ae9ceeb9427fe79b"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-X github.com/tronbyt/pixlet/runtime.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "gzip_fonts")

    generate_completions_from_executable(bin/"pixlet", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.star").write <<~EOS
      load("render.star", "render")
      def main():
        return render.Root(child=render.Text("hello"))
    EOS
    system bin/"pixlet", "render", "hello.star", "-o", "out.webp"
    assert_path_exists testpath/"out.webp"
  end
end
