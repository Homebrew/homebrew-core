class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.18.tar.gz"
  sha256 "aa9ee59a52fc45f426680da48f45a79f2ac8365c15d8d7beed83a8ed71a891e4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cb72c1182f1f323ce607fe9e016c3cf9352db57e18384da6b356164aab751cf" => :big_sur
    sha256 "1d7ce2cfe475ced9a092cf4c8c18d34feab5398249bc8672235c13004dfe9206" => :arm64_big_sur
    sha256 "65f9f13eb5c2f53afcb697f9699f8dd6b9df5f400908a2d3423879f8ca895942" => :catalina
    sha256 "73ec9efeaf423dd32530bd4a547b11522b54dd5666942735268bb7690479ff09" => :mojave
    sha256 "190e2e02b890cf099ca52d1468b224d16c82840a3a534db83a2aed5553b07bfc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
