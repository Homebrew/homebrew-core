class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "563ae6b0fa279cb8ea8f66b4b455c7cb74a9e65a0edbe694505b2c8fc719b2ff"
  license "Apache-2.0"
  head "https://github.com/chriswalz/bit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6e2c5d5baedcd742c9f2808e15e1310c4762fe49bde321b2786bbdf5e5746319"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "512fae594f8692aea23014f35c5ef02d23c49c2ce28b2f772cffaeadc55b2c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a28f8da02e22757fa2d836e5767926918410ab8f85f7e46ea330d5d5255b937a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82fc55cd7f3b2e7fa64bb366e4ca6e9024510df3e734e8e54800dcbda8870c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec8c891231ff16cf80a718430dec65bea587391dc0ebe31494fea95edb44723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc0139db7fef5d988bd822b90f8551d8ed5a5cdccdcc71520ae6f326cdad89ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1848708a2ca3bf3ad52aad8e4005adc464b824da5b38c3eb69bc80d9c8979d5"
    sha256 cellar: :any_skip_relocation, ventura:        "23bc09ee2722746a76d3fbd4dba8d4f8d9adceba6e558c2f92ba051f385081d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e80cd43fa56f86ba282f2f91ca68336eecc331119e78e5757e53a3c4c5f9fe37"
    sha256 cellar: :any_skip_relocation, big_sur:        "f321a7d78c247054446dfbd07a46de743a36ad591f034e2e81c93b443741288a"
    sha256 cellar: :any_skip_relocation, catalina:       "4e4e377fc26a5574fa6b38f63f2aa1979f0639854ece3a14cbc95fb6a2cc037b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "353231b7f6e264d45c4aaeac8e79b17bbc5dd10f917c333725f28084644824fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9242804e17ecbd8e6a42368a26c83fd8d97567ce6adbe5c2471dce9f6969f90"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")
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
