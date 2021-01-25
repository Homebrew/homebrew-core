class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/v6.3.0.tar.gz"
  sha256 "4e1bbbde6e5ccf9d766ffd80c8f6d232f5a4904b63e0b7102396d2766ab486ce"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c5bad9e7f55695e1cfdd2eed013d16ca3b5cf6853a6834a0ba7b1de294afeab" => :big_sur
    sha256 "79e5bf8e174902a8db25c31f379a29b7a59ca1007c75f0e32a1a2a66df5d14f7" => :arm64_big_sur
    sha256 "c8d8b1fedc2205d8ee93b686df168d8045eea70494cd27cb93ba308d305a9ccd" => :catalina
    sha256 "b6cbfda0d1461c9afaf3f00bf8fe215ffcf7d3a1732b2dd829747740d2ba69c5" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/counterfeiter -p os 2>&1", 1)
    assert_match "Writing `Os` to `osshim`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
