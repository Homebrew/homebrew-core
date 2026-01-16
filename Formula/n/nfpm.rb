class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "0c663bed40ce3f39ba605f7fe7f536d5474ddc0988d0ea745e62fb72b3650dd2"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6656bec6b67f9d6c24482b261725ab96d56061ddcbacf461962779be7d521437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6656bec6b67f9d6c24482b261725ab96d56061ddcbacf461962779be7d521437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6656bec6b67f9d6c24482b261725ab96d56061ddcbacf461962779be7d521437"
    sha256 cellar: :any_skip_relocation, sonoma:        "3023c3cd747a5a59f6b742387e2b6c5002c97e554ce892de04d7c6dcff4295c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a633d61616ba235ee99640c56ddda7dfe50dd5e13f5f69dfd6cb89892ed08067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec89cf62d19545e68eec6151b8bc51d38336bb9cb92248a2353aa29d6a25c58"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "This is an example nfpm configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~YAML
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    YAML

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_path_exists testpath/"foo_1.0.0_amd64.deb"
  end
end
