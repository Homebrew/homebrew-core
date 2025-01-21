class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.3.0.tar.gz"
  sha256 "0b614cf4317a16c71edd7ad5973a10930b5f5ef342eb6dd840ada9debab61d70"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5e462831f84464e6dd2ccd9b412851430d07aefbbbebafa02b6ca924debdef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5e462831f84464e6dd2ccd9b412851430d07aefbbbebafa02b6ca924debdef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5e462831f84464e6dd2ccd9b412851430d07aefbbbebafa02b6ca924debdef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b615c087c3c76e1824e4cc5e4589f013c7fa751b00615f6027fc5f7638ea9c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "b615c087c3c76e1824e4cc5e4589f013c7fa751b00615f6027fc5f7638ea9c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8bbefb970f59bb5d970eba3f2ecb5b82b607b06eeeaf4e1b93c8fe8497e598"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
