class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.5.tar.gz"
  sha256 "31b4600d221111e5866581ccc497a37985b0a81939f95061aebbdfd8d08c5a87"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6560b5ead8501402b6078b340c0c9cf6e15414b9ca5e5d414e304d0bf6ef488" => :sierra
    sha256 "1f8d6ac982535281ff2f41e8d57d3930d7bbaadb623c7fb4b10fefddd4a46d02" => :el_capitan
    sha256 "bc598d8b19bb11fc3e3d87bfc6d9c089b440a03262ced8760fc0e328aaf04d0a" => :yosemite
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
