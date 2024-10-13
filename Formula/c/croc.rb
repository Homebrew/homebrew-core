class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.0.13.tar.gz"
  sha256 "69a7e60811b97d3f6e2ceac4d24fc52596ec8982039811fb5894ef78f2dedc77"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef28473d93b4bfe50c2ce6013b60c33fc8510acce05ec64ba2580e4d41a08db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef28473d93b4bfe50c2ce6013b60c33fc8510acce05ec64ba2580e4d41a08db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef28473d93b4bfe50c2ce6013b60c33fc8510acce05ec64ba2580e4d41a08db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "48850c376a5447d6607157dfb575429439fc28c1c962c3cc64613683b178b27e"
    sha256 cellar: :any_skip_relocation, ventura:       "48850c376a5447d6607157dfb575429439fc28c1c962c3cc64613683b178b27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a478aff4e3ea88bc65d7c48e46a13d87683d8cbd0cca0491d68e02da2eae57ac"
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
