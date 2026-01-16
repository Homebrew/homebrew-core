class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.49.9.tar.gz"
  sha256 "5d0a9aeb2a99bc61e3029e2c1d443c45a82371c948109564d5d522dca9c1062f"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2abf5a48bf5e4e0d44639063cc1a170927526bfbd1ffdf8045482e847a9b3268"
    sha256 cellar: :any,                 arm64_sequoia: "967cd15a2f052b361972d5535208a1a7a779d880b80a97a5b992de4f9da0b246"
    sha256 cellar: :any,                 arm64_sonoma:  "f04c5eee3066b198cdeba1fef2ad59ad49348679d2d5ab57fe552801d3fa6cad"
    sha256 cellar: :any,                 sonoma:        "88171b8302dfa59bd74c84f1ba041766f8b50bccb493505f8ec82fbcb0588e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb20f699b537d640502a6fb6042f506f6555eaa47a60b48d7ead5ca4f43ad6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61dc9caf704f1479085640f1ae9633507f159901482e6f7a8ebd39773d83dc38"
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
