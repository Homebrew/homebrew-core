class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.13.1.tar.gz"
  sha256 "907c98ca0c6b9f1137c6df0f116058a2bec9a4565f456fcc9ffb26c64520ca58"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf4b93415a8146abf09d76e51f1a6532e94e5004ab67d9d870e0d2b167117b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4958a8301b257a0e19af06d9bc774c18d63c6ef1dcdf621b30f4c562412615df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a7f22112c32d3ba58204877894c2b8a5f67ccd98286945acc3831dea85eb44"
    sha256 cellar: :any_skip_relocation, sonoma:         "72f5f5ca39896b9b1305822bfb26a441aefe816e3dfd9a5fa624ab106aaf227e"
    sha256 cellar: :any_skip_relocation, ventura:        "c06fe649bdbeb15b225bb94ad4fba5cf072ec7aed0981e02e5ad8abb8cf96c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1ab4b0bc288cceee98ad8460cce9e6785f2e8ec0cc32a7f356e46ca7b69038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da6e14b586cdfe3919fb5223f5d8f9b44ff75a71d6dc57ce1842f99e87343cb"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
