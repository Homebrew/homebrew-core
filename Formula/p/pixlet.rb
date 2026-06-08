class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "f26925bb4b8bca7b2b67009f93307ca486914e10c5c37edcd542149bf25e3aeb"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4413f185ee4f0ddc705d7d6c3da0a36eed0487777cc99b063490fb3a628ff356"
    sha256 cellar: :any, arm64_sequoia: "85f7fd65f3013702503d815a526ca91e0818c33d91991332357b8cecec2d36be"
    sha256 cellar: :any, arm64_sonoma:  "7ff5439a094f00869daa8d18f10dc9bdc495d77f652753eb744f7efc0678a186"
    sha256 cellar: :any, sonoma:        "4420ff3e61ed54a15d97e7c4cbbbc84d7fab376d92ba55c3acf7ac2a376b6a8c"
    sha256 cellar: :any, arm64_linux:   "977ae0263cf6523a632d66bb56078f15768cc5b75f643838c827c07d9f0659b1"
    sha256 cellar: :any, x86_64_linux:  "66d1e97582c6e6e9caf7e6bb175940f836e71ab3418e6684b2234ab30e183289"
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
