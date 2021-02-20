class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.13.tar.gz"
  sha256 "4c91f4441b593c414f571abe302ee07aecc9044be4d9f6eff39da1210ef3df50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83baa9546cf664f7d92424d38138f0a65d18097a361e634c9567b8b710f6d80c"
    sha256 cellar: :any_skip_relocation, big_sur:       "88d3bc526a8ed6c8a0c21fefa5b2a232445fdf315ddcb7e19ba8663f802a389d"
    sha256 cellar: :any_skip_relocation, catalina:      "ddd16eec937218aac660bef7888dbed9342efcfe112835c6b53ac851fe2faf94"
    sha256 cellar: :any_skip_relocation, mojave:        "b0a0810589ae45fe1ba557c6c26da9cf0b864c853ef1612bcf4750de3cc66ce3"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}"
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
