class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "74064bc74d26ef982f5f306d897fe4ff820ec4ab6322f6c96d7e48659f8e2346"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e24afc41bf2bffe73c36ca49b0da7bf7b98c2a4a11e872f8ebdcf5c1f0f04cc3"
    sha256 cellar: :any,                 arm64_sequoia: "5a41fb0298eff4baa87649b07311624fa39e55b3dfcd8f49fab20bde89cdd666"
    sha256 cellar: :any,                 arm64_sonoma:  "3cc0c429a51c1ba377ce64e930d92072296e0d9bc477b7cb51196943a6e4cb48"
    sha256 cellar: :any,                 sonoma:        "c23b800667e21edb0ce3eeb59fcf50bafb9e6f4c139e9dc0af6c7b09ad2ed72f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961f6ddb5b7f7d5a3e163aa0676e16d4d6d061abbbadcf42f64890065e5c637a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e716c33ed4cbcee72fe024c8cd380dad4bc8b1e04c2ec1f9e3a26399db3a8f80"
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
