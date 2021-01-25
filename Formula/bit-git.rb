class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v0.9.11.tar.gz"
  sha256 "a6d7f31d92007725b18f6203c7b9c8f9eaaa49e22f807ad683473d7388350681"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "10fe23fbb229098ef6548909184ff2173f6f55831f01a9555d91c2c7ec6808a2" => :big_sur
    sha256 "eb6215146aff190aee0e9fe5764123bfceddde33b53d796d77e43955159a1dc5" => :arm64_big_sur
    sha256 "627db9ab99558d5515cc6de83dd6d79fea1fb6dffc4541baa0aa181f24de1732" => :catalina
    sha256 "43dfd72b27f1e48b105c5175da4993dedc809438644a3b9401b1d567c2b1325d" => :mojave
    sha256 "23c7ec23e0d0da58e0b2da1d48fb740727765981c414269f9f11637e813e111c" => :high_sierra
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
