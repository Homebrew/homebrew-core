class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "a875f81394111f31c528d37c81ac6a48a1cb06a776e62d03cdd584e87c145634"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74115e1b7813bec37dc1bb0a26b4d43e14e5fb319f397df76462e43ed3daa0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74115e1b7813bec37dc1bb0a26b4d43e14e5fb319f397df76462e43ed3daa0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74115e1b7813bec37dc1bb0a26b4d43e14e5fb319f397df76462e43ed3daa0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f049fff01ed84e2c0c0ac04db714c5fffa17def11291d54ef1455c73f59c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7907e2fe5be02bf2ca5979b060f3b17d1914cc827afe05c2bae11e45583dd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4326a538c0a2bc7a9b187371c6c2bbeac9d51f1a7983358df25407d278d87e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
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
