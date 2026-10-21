class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "c242983d943662beca7d3909f68f0b240424d94a3ad3785a993aace2658dbf89"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f08d4dddde0b30f9115c0ae9a6d43d6d8cb7b2997052adaefdbe53dff627cff"
    sha256 cellar: :any, arm64_tahoe:       "c3b71893c908b09b4cd899455f4d8f614e7084249f57703bd881d099a9382eea"
    sha256 cellar: :any, arm64_sequoia:     "482178efc0aae9e070664820fac6717485a3d8a47faf63c2a7759690bdf36217"
    sha256 cellar: :any, arm64_linux:       "205d3574c90b6b5926d023839627d2461d3f0b2e8643cbc585c3c199c8a41d37"
    sha256 cellar: :any, x86_64_linux:      "8ae01c7e2dd849b10913f1cf1490f85515f6e91948b83b3a2f8d79a938723ba2"
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
