class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.3.0.tar.gz"
  sha256 "3efdb3ded13c18ef256f3fccf40ce3a04028f4af0c0e571798444a23fb9f713b"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee0342c354c884c1d44eaaa17a8ba887a5cdb4db094ffcb2a7671670bbb1be7b" => :sierra
    sha256 "c51421d7d5df89f771fe8497d0e64664654cdce2edbfa6bfab5c721d46039f09" => :el_capitan
    sha256 "093eb39ded8f6bda9182a5b53a25379e05f9ee3fe3b08a44095a6c1338d33db2" => :yosemite
    sha256 "8ad823f80addefadf372df10c2343af9181ec13af70b11634559eca45524dcc0" => :mavericks
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
