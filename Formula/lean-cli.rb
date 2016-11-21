class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.5.0.tar.gz"
  sha256 "b7778e9e6ee10ddf3c5f511c43ff95466b1648763dba1e959b88282dce975e67"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08f531edc2cfad618f333dd4ecee4d43d216190b19f400e6ef6b8a789462049b" => :sierra
    sha256 "f135226c7bb6fc692b9bfdab19176617e6bfa2a4b6f0bd9e9dd06382181cac9e" => :el_capitan
    sha256 "25c0cc5e092806093ba1746ef27a50950380cc8f184aff83d517218b25928d60" => :yosemite
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
