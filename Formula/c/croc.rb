class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "78bf0efd00daa9002bcdeb460f4ddaf82dde4480e63862feab0958ed9ed54963"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d2dd117f4d04c989150f176fceff9a9a9d98c3242e35dcfe8224f5d9d2e301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d2dd117f4d04c989150f176fceff9a9a9d98c3242e35dcfe8224f5d9d2e301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29d2dd117f4d04c989150f176fceff9a9a9d98c3242e35dcfe8224f5d9d2e301"
    sha256 cellar: :any_skip_relocation, sonoma:        "46fc3bd877cbb05c6f6cdd2df4becee3c97c14dc9d055a05acaa0a2d70a30780"
    sha256 cellar: :any_skip_relocation, ventura:       "46fc3bd877cbb05c6f6cdd2df4becee3c97c14dc9d055a05acaa0a2d70a30780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2297a164a96e3f724731b20cdb72c32d22cbc1003eefb458713aa36c5298a7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
