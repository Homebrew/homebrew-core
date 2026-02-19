class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "ffe0384889a25636a021f7a9971b493fc807efb05a23f9f802a9b1c564f35a95"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc71de5b1b6acb24a8168146ef42be52957c7f55400b1c29ae033abac17aabf8"
    sha256 cellar: :any,                 arm64_sequoia: "256dbbf76d07dc801cdbba61b9e37ac6b92ee3f0bef2cc9e053eedb9fdcf2471"
    sha256 cellar: :any,                 arm64_sonoma:  "e24896d17e89280dc805b75a09e896b0c45953ef47d304e9f8e508297e757746"
    sha256 cellar: :any,                 sonoma:        "0dbd99fdd83f1136457c6f7b9ef3fbe23acda0ebc7d13d4a68084ba28391c28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2448607713d9e93eb30e360bb2e616a0f2a73d3e5896c3f72781a3bd4c99d4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c56231a19f351baced89816d726080cea7680c035bb1ce4a0a3efee6e2c149"
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
