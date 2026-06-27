class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "35ba194885d5348b38f1bfad107dd9dafb3f835a227f1354d9e030658b135216"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5111ba7966eb4a82fefdd85c16bf29867fa56fdcf4fc48303052756638d19d34"
    sha256 cellar: :any, arm64_sequoia: "66db1abf90c3b052f46f73acc50bb475c8962c24a127e5568c4c853087e0105d"
    sha256 cellar: :any, arm64_sonoma:  "03a31f36ad81ad44bf13b332ea96c3c5f9eababe32ebcc6d15b0e540a6a22583"
    sha256 cellar: :any, sonoma:        "53b29bb12264d85880b63e1b8e420913622604167ad88b242c5585e874253485"
    sha256 cellar: :any, arm64_linux:   "ea933088a1ec05dbc044270b34ed633e83b628264eea1a11f0e48a99a1d12447"
    sha256 cellar: :any, x86_64_linux:  "1b8145ab62580fbb12e5fbdcc2b92d1762cd53ee760055aca5eb5b98b8977617"
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
