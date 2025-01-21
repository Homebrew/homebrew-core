class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.24.1",
      revision: "be051153525b018a46f71a2b2ed42cde39a1110c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f64993358c0dbf9148225c06d2d188f662792221602eda80b0c3b18460a774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f64993358c0dbf9148225c06d2d188f662792221602eda80b0c3b18460a774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6f64993358c0dbf9148225c06d2d188f662792221602eda80b0c3b18460a774"
    sha256 cellar: :any_skip_relocation, sonoma:        "da5a6148836db44d966471327fd0f7c6e99921c357540476ba84b004ee72c29a"
    sha256 cellar: :any_skip_relocation, ventura:       "da5a6148836db44d966471327fd0f7c6e99921c357540476ba84b004ee72c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388d54eea16a31e3e7230847a697f2e3ac93888c9869079ba30942c16dc7c8fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
