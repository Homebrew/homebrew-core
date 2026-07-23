class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "84979ac689ba26dc0a086b245cb0a3f3e6a7a246a435b2c757867e76823187a5"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ac70d93a74e61aeff4697f5aa6f2828faaf7a7d92cbf22e731662f754b3f436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ac70d93a74e61aeff4697f5aa6f2828faaf7a7d92cbf22e731662f754b3f436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac70d93a74e61aeff4697f5aa6f2828faaf7a7d92cbf22e731662f754b3f436"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf83f7874c1cfe9be3319a323bdbe9665f1971d9a2ed9bb3b6e848f6e2f942e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bea0d8a418386d30225006b82bb0fbab87da17b3ea74a7472fc7312b4d52a25"
    sha256 cellar: :any,                 x86_64_linux:  "a4d24fbdef8dccf6b987ac9173abec27f467d30357fc438ba0117ab0971e4a10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
