class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "bbd4cfe503c78ee1be15d82e29cec52ab62ac88e18ac934dfb6ecee404d6fe13"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5e9bbc9c7def1776d587192a4f6be150e943e0c6891b7795dfad814e8bfd5b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c36ed549f681f70fdfe13213564f2a4aa133860ed84b9b482765be64040b101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b5a0d33b8d2fe58a738a63aa0915e801d1d38cd260835a468cb67eedf1bc45d"
    sha256 cellar: :any_skip_relocation, sonoma:         "31effe258d3bc6fd6071ab37904ae7d9f49f6ff8bde293a6a2f5bcad67590d59"
    sha256 cellar: :any_skip_relocation, ventura:        "96bdd0fda1b14b6bc86d2c29d0c8fe3b9c8f0fff473175410b919e6864d6050a"
    sha256 cellar: :any_skip_relocation, monterey:       "15681a555b37b20a752012a39f15744951374677626498629a777d2749efe334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f1d7d4e7ef6a580c13e3cd5c5b26dc4bb6afd09ebdb16834a778efca473832a"
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
