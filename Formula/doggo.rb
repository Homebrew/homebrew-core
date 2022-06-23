class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo.git",
      tag:      "v0.5.3",
      revision: "ea7cb3c6cd0467a7db783fbd30aa8599604a76d8"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = [
      "-s", "-w",
      "-X", "main.buildVersion=#{version}",
      "-X", "main.buildDate=2022-06-02"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer
  end
end
