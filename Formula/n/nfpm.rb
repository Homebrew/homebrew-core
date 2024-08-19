class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "cd7ce7a003275266178c55882668a88f5309cb7875ec74f71562dcc72c58ce32"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1790fe2cb7093849fc81110d7f2141d341627a48717b3a763db430e2f419db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9af058d6666c4090768ac38e266f593faa642b9a4b6b4b075febf4b7251dfe5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a56beda6dd22daab61d928c3e1d113024ced2c3350ace76d2edf9c63ea845b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f37885f9f99d6c70a9e14a27473532252f088ae6877093bb112d373c11e6c40"
    sha256 cellar: :any_skip_relocation, ventura:        "3692bfa454950f479d2628da194cde9f3e50ced89797d80d6702e3048cd3a9fb"
    sha256 cellar: :any_skip_relocation, monterey:       "3fb0570c3bea8b02b6b8ba10e6538e1ced0655d175822e87069c210520d72888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4407f80841b55b6d763b8d77d172440597d0e61f5cc17895762bd566bea580"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
