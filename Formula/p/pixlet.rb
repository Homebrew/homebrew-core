class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "ffe0384889a25636a021f7a9971b493fc807efb05a23f9f802a9b1c564f35a95"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18a5ae8b863c18730bcd47c22cd5f73dc2ef3c939091a2d6cd340bd82748cb7b"
    sha256 cellar: :any,                 arm64_sequoia: "62242e4df41a95b332c94163e1bc37089df0067aa3f0ed82ad9b86a130d720c7"
    sha256 cellar: :any,                 arm64_sonoma:  "b3fd5bc3714c392e18515cfa89d07c04f47bc9ebd053c0660fd89057cd24c2c5"
    sha256 cellar: :any,                 sonoma:        "575fb987d73cea801900e8e7d366fcc71a77b7e6f2773552a224f444b674411d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca100d70a22f9793204d610f69b2832164334964121e6029193c5a0f6cb0835b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89681b17601a651c3bf144b8b46c72c13b52342e2e16dd8341c45c142d91ec94"
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

    ldflags = "-s -w -X github.com/tronbyt/pixlet/runtime.Version=v#{version}"
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
