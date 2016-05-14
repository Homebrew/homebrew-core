class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.7.4.tar.gz"
  sha256 "3cb89e6aa91676ffd0577798a4b06b056667d18ad836de4fa31c0564ee48474e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ba2e364ada8976e9141d22ee99e6710d579ff42520731a3769c5220454cd42e" => :el_capitan
    sha256 "280939d812078baeb1bd49f6695b7ce5805bf6b26cd452edcaa85b23205c4ffc" => :yosemite
    sha256 "0c7cf94128d2a4d9a927842ebf61047ab263e2da2e749e8cac4a77a0a36052b6" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
