class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.41.2.tar.gz"
  sha256 "d0b864904b21f2aae6a3066954c8f75bdc456ee1ffa2f76110c24af23b5b3473"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008c765df6a276b766de022374317039ac6f93ea327ba38f21a73dac7dfdf30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "008c765df6a276b766de022374317039ac6f93ea327ba38f21a73dac7dfdf30b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "008c765df6a276b766de022374317039ac6f93ea327ba38f21a73dac7dfdf30b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6ff2785fe44e2bab92e30512ff568866c91c84254db886a7c0ba3490c96c56"
    sha256 cellar: :any_skip_relocation, ventura:       "0f6ff2785fe44e2bab92e30512ff568866c91c84254db886a7c0ba3490c96c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaaa53b362dda9e766e5713263fe63866983b3ebf981a72fce8bd729efc80692"
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
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
