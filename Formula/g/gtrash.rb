class Gtrash < Formula
  desc "Featureful Trash CLI manager: alternative to rm and trash-cli"
  homepage "https://github.com/umlx5h/gtrash"
  url "https://github.com/umlx5h/gtrash/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "66003276073d9da03cbb4347a4b161f89c81f3706012b77c3e91a154c91f3586"
  license "MIT"
  head "https://github.com/umlx5h/gtrash.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3b1bd8138c592581fc7ce7f3258e8cb63f0b249924bc868e73f24d6ddb2738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3b1bd8138c592581fc7ce7f3258e8cb63f0b249924bc868e73f24d6ddb2738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3b1bd8138c592581fc7ce7f3258e8cb63f0b249924bc868e73f24d6ddb2738"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fcca14d1153b9a849fc117ca195c626be58f2466c46684f2cfd38392a6012ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fff31885606b9a3cf5642f91fdb40529488b74ff646913a72577ef156c31d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e639a18c6dd01c500543db61e10c3588abf938d46687d36a14be74aff27cc07"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gtrash", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtrash --version")
    system bin/"gtrash", "summary"
  end
end
