class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.11.0.tar.gz"
  sha256 "70ce4e136f1a6655c37a52474ee8f3808e5e915bb63d12ff236df1efafe4ad06"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61f18a2082a809164f180ed8e2c6190dd808f020015aabb1e41606d8e2bf8676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e80bd1980809bc29cce81804af7c1dc5baefaef378f09c8a63a75f59d2932ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26034247c0d3e2fcb7fa1ac4c1da7832086c55e9f011157961f1bcd8e18a92b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "12de9510f2b9b4b763d50e6cf603810b4f8f5becb4ff04dad3d6f387e6a1f0e4"
    sha256 cellar: :any_skip_relocation, ventura:        "3de8402817723302f595572c4a8588f24cfdd03a659268768eeaf8515402b85b"
    sha256 cellar: :any_skip_relocation, monterey:       "a126fbcd283aad23e56dd678bfa75330d3a19c8cfef8b682df30b65b914363b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51dc486afd72ba79253411a796cc3de5d9af2e7259aff41458dc9cccf4bdbdd"
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
