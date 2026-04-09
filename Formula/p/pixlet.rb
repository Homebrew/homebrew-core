class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "4c796ac25041000d9d04d5e92e30790ab232778451aaf715e203b66d1dd12840"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b13307e83629598bf6a43d4e6a7ceda39c8d83d5b7e2f2d4c744b5e49b46be9e"
    sha256 cellar: :any,                 arm64_sequoia: "cb3afde9aa2fa185eedb1656bda5fb4445baa1878a85583136bc23691cc4364c"
    sha256 cellar: :any,                 arm64_sonoma:  "0f95bab0dc2c2372baddd8cc40f15a113e5f8fdc05f20188e2519656bfa2c314"
    sha256 cellar: :any,                 sonoma:        "d454da2ff15e904f3c6f1eb2345d694bba369e6c6dcf9088a6fa254b7acb59d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3551298753d469e15c6f2a5f88fb88b687c4423a5e6b2f52853aca22e62d9e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ccbc5242978bae43e39cd34e276f63b1258bd92dd06b188bd15d45ce5065f7"
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
