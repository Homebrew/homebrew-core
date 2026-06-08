class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.46.3.tar.gz"
  sha256 "b5b46bc6e7e9b5b9db4c2ffb5937d7d8b371fd573ffcf55f179e8fd81f7d1971"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d4a3e5ef9fb2af17bd45870774e4b1b362830a03a7e7eb1bbd469c285b6ed2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4a3e5ef9fb2af17bd45870774e4b1b362830a03a7e7eb1bbd469c285b6ed2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d4a3e5ef9fb2af17bd45870774e4b1b362830a03a7e7eb1bbd469c285b6ed2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d666b225c327cd3c20645c7531fac231f92d7da0ddd2e6f4da9e2c569118ceb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583d6a209d683944020c61cb6401d1c1a9220d09b9e3f36cb75501fd2cd5f276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafe3b12734344c61d4b6b6d0a8d1fb297c67e44b2c88addcca8aadc6cd8ef09"
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
