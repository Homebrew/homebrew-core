class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.42.1.tar.gz"
  sha256 "02188194076de423a5e496dfb8a09d4da000e9c812ed30310a1c8bf7dc6c7ee3"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52862fabd2d42630ba0b1acdf518db4e425fc61c601cfb2dd68701524cba266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d52862fabd2d42630ba0b1acdf518db4e425fc61c601cfb2dd68701524cba266"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d52862fabd2d42630ba0b1acdf518db4e425fc61c601cfb2dd68701524cba266"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4311f4ba1a9f7cce4b1cac8ac69feca786b408a3db7d58a896ab06bea6432c0"
    sha256 cellar: :any_skip_relocation, ventura:       "e4311f4ba1a9f7cce4b1cac8ac69feca786b408a3db7d58a896ab06bea6432c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8cba097ac5d4aaeebad337943a72f50578c8192496e2a9a535cacc6c0bd03b"
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
