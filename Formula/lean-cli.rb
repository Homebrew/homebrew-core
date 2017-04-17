class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.5.tar.gz"
  sha256 "31b4600d221111e5866581ccc497a37985b0a81939f95061aebbdfd8d08c5a87"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24128449b4a3de2b9bf21d19802be6fcce24840ead4b6dda940c679e583bc89c" => :sierra
    sha256 "6ee3496dcea614e9fe840681cbda7272260610f2a34fbda366ae5419620ab4fa" => :el_capitan
    sha256 "cdbc50b2492f0a1c8eca8e6ec5e272abeabd835961de517c789020699fa475b4" => :yosemite
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
