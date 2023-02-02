class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.25.0.tar.gz"
  sha256 "76f260f7c04a28bf64d487ee017dafd9d6bd5aba2b4a61782276b384aa782e3a"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28e530964f58c26dee346e01bdfe8cca185ecb8ff4fe5e0c535165be6f42d56f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "790e8467c0d86ea5af83f6f2bfd40fb03fd8e19c71d57c91884e0eee6b18da05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2478f1432fd9088a983b53ef85274e2c767b152d83b706b7524fe5bfc89b5cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "a33f9aaed0b596efb4bc2bc350b48a37dcd48d46842ef8bc00957d8ddd46b9a2"
    sha256 cellar: :any_skip_relocation, monterey:       "79ebaebeed8b03f14a1c469a9b7bb9caf19aa0b015808de2dab8084328d80a18"
    sha256 cellar: :any_skip_relocation, big_sur:        "1667bd2af02607b334591e46274eae889343216b96f971f7585c5acfbf59c36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66478ed81457a23ddb81bc9abd889629fd063b7f776fa030d60a184482a94c5"
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
