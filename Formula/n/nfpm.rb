class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.33.1.tar.gz"
  sha256 "9185fa81458b9b8b8cc227782a40756fc85e70ca3066b5ff709660897d28aebd"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a94002060d1d72dbdabe87de00f8147c9650c004d4fe1668df83d073b6f31d74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c479228fc3533a3df2e543f10ad42bf48daff034183c09f172d0531928e89a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "499938502939854dc45ea5114c8bb27b4ef31b9d0d302844f8a8d019958387a3"
    sha256 cellar: :any_skip_relocation, ventura:        "470b335aa5d7dd598accd9d722dd7fd56c8df8dfe483a83ffcc6aca020efabe7"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b360f00f44a137e04295fe2a2ddf26654aef32736f80d28364fd5ac140220b"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb397eba66e6a98a17e9c28a22723ae310b0dd0aff0073e33e261835388f6763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771e09077dfb4313c613fc7cb46fb3c40dab00af9ace83ae516b1864da90c6bc"
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
