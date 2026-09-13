class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "30466e15586dfc93f2bc049ddaa3a3df51df37b750476eb3b2a68565362ea4e9"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aab15baa7e35dc54dbf3d3ddb7bb4b5eb43abbfb811cf8e910d3c5a4d9977a82"
    sha256 cellar: :any, arm64_tahoe:       "85c05cc2099f02296b1d81c3ddfe9555b2c664de2790e0d1146d600adb82b8b6"
    sha256 cellar: :any, arm64_sequoia:     "32db254c50826fcc8ca1b94f0658c4ebd8d8db3454ce05eba536e950ccd020b6"
    sha256 cellar: :any, arm64_linux:       "f1da521e60f357e860b6bfcd23db9b55c8975b5cae7aff3fb0fac31a4f705199"
    sha256 cellar: :any, x86_64_linux:      "41e1720158ad20413a1d69d7cbc18b29abb7efb27e9c9a61dfd308575febdb16"
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
