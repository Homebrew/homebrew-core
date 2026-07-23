class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e1d70b683cbf8d1be505e818d91ef07c6938c82affc914eaf88f25d4f81edd56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3974a59cd7a66f2f4db021e85d5a4460b500cf91899c908f5bd2c2cbab17dfcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0ffa53ef80ffb3a77f3329df0e76ec6a586f2facfd2527f5602e89cb989fbe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e121cbec264d8104746ba74e13d296528b1fe5c549e978bd731956a6a6f55e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe4a5865bcf420a0b4e403e888002e19a4006d07efa0f705b5c0fcd32498923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ec4cfa3dadc8e05a3c103f9471a4486e56ca6146c66b5b91fc4553b63484d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812a89c8aa390f9eaf7c788fac3ec8bdaacea1fceeb7169764502a4c287e2826"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/pk.1"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
