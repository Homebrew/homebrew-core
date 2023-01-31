class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.2.tar.gz"
  sha256 "33bb1c017907298117c2bcb7b36684fe1890867c7c8c13faaffd3444d403a5a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95be0caacea69efda1f425d7b830af7c8ecfed5f07ab03e64631682590f458ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d524e4378841b466515bd342db6c788fc2600cd1af8556d8bbeff326bc982738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5264fb3e80f36d223e933717ac913621d932b95967c90bdb61d76e81a34afd3c"
    sha256 cellar: :any_skip_relocation, ventura:        "fbbfbcfcd86dce433d36a43f03a6a328a91ecadba5037c7c0405b42fb574d11a"
    sha256 cellar: :any_skip_relocation, monterey:       "1a76d884ba541e3ee64ae44fa2fa1833dc7f8b0c24c0dca06803032936cc639b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e951322bade666b65da11e595744e3f5e52e22ca789b3a3315429cbfe26b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86158640413bfa57966bf96d7846bc5524e6669f642a8055d09b5012525591d9"
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
