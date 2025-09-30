class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "b8106f5d2fa41f79e33389891054a23401c33f456da312c0aee380278feb0410"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74e55cdd77862b9464f43fa44a147a98eb7f15a42d38e77b35412d014a480c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74e55cdd77862b9464f43fa44a147a98eb7f15a42d38e77b35412d014a480c28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74e55cdd77862b9464f43fa44a147a98eb7f15a42d38e77b35412d014a480c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f2cc265e8452f8e6bb01ffe4dc0dd31e963705ac7a4327233fe42b64340b5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1556debb286f1c631f28daf6e9347561cbdae2d917c56bf010bfdc7d140853cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
