class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "d4abfac1a39876ec1e6c6fa04ec0b62cc4bef174f11d19848bc80dc15ee05261"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e92a349b08740b3610079e799d5f80870a912790bff674a2da456859d38697a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "793f2de5437dab04d53985229024b5ebd8f53c08932df8777da135c71356d745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "793f2de5437dab04d53985229024b5ebd8f53c08932df8777da135c71356d745"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "793f2de5437dab04d53985229024b5ebd8f53c08932df8777da135c71356d745"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c0aa4a5126a4ada7dc36f18f01ddad84e448c275cde3d75423586ced6c5343e"
    sha256 cellar: :any_skip_relocation, ventura:       "1c0aa4a5126a4ada7dc36f18f01ddad84e448c275cde3d75423586ced6c5343e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26fb1ee2c4bf8f45e51e3a53d8503c2c60c50139b9d9a333e11fa0ed4904ffb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3030c623242031fd6262a4eaea9919f3f7941376b2cdc192f88c21fa48b11d5"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = system_version = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{system_version}", output

    # Test an older version that bazelisk will fetch
    ENV["USE_BAZEL_VERSION"] = fetched_version = "7.6.1"
    assert_match "Build label: #{fetched_version}", shell_output("#{bin}/bazelisk version")
  end
end
