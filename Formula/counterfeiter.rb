class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/refs/tags/v6.6.1.tar.gz"
  sha256 "33cde81680e6694da451862233e20270581fb40d3c490efb67c4b5e3a3ad885e"
  license "MIT"
  revision 1
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2848e9d73b109da41de138bccee3ad15c923a2a692b0a3d76a7d36cffc958ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb93e13a4af27fff9048d2e30d8369476ecb82aea961333ccf10442ce693c0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0165588244c3e6da51aeae2a004713add997a6c57116595e4076f4f6e70ffda6"
    sha256 cellar: :any_skip_relocation, ventura:        "0feb02c66fba1c465552f88e84481a5768e3ae6af77c7fa5d78fd44a2fe761d1"
    sha256 cellar: :any_skip_relocation, monterey:       "5811e4ef4446b5e2575da1ff06dad56094b2a43b2308a605cc1174e342c7872b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8565f9078aa1bb68cf18674d70ea4074ad88ef743cb79034f8a9a1db2a8c2bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "956477417ee2bc8303141fdb8a51570f03abc98f8ae31a536636d5d960b19a99"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
