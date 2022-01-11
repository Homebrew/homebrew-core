class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.9.tar.gz"
  sha256 "b1cb4108d1d35c8e2d2630cdb78a42e1e10ff36ea00ce2e76577e1723905d4a2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de48331a0819e96a03a39749439eda8a425ca8bc779fdc8f6a66cf8c0b265993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "198e02be02d2fc753043de25b4a3af0413de1e14555aef56fcb2ec4873c8c953"
    sha256 cellar: :any_skip_relocation, monterey:       "4db23e9443982fb98b5ab51bb21db3546a2a452f7e5b452170d73be37e90237c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b546442020191ec01fb0d6805fd59bc33d2b6b791f1ad8b4f97a252cd4777137"
    sha256 cellar: :any_skip_relocation, catalina:       "3dbf324dde4a70d1d97fd7ab1331df4dfec1bfc716e022223ef6df88d7e8d9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89521abb5efb2d069fb3c8cc8ba885c39f5b2f5b2524445cc78b95b8825349eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
