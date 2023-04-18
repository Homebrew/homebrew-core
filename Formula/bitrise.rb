class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.5.tar.gz"
  sha256 "1947b7aa24d9907be06cb0acb8706f0b6ad1f3ba900457a72679340a312a3ceb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c0288ed60ad95d515ea13c417dda3c327e98e5b6b482debdd5ba49ff6fc97ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0288ed60ad95d515ea13c417dda3c327e98e5b6b482debdd5ba49ff6fc97ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c0288ed60ad95d515ea13c417dda3c327e98e5b6b482debdd5ba49ff6fc97ba"
    sha256 cellar: :any_skip_relocation, ventura:        "65df4088747c06b341e154fbe1d4f3090b62dab6fb70d69c6125c4b1767df8e7"
    sha256 cellar: :any_skip_relocation, monterey:       "65df4088747c06b341e154fbe1d4f3090b62dab6fb70d69c6125c4b1767df8e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "65df4088747c06b341e154fbe1d4f3090b62dab6fb70d69c6125c4b1767df8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64eb43074aab757164c2a7be3e9dc44242478c95267ab6373d2cbcf287fcda4c"
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
