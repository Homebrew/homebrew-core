class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "0f70e14d408f6129f2a5621053ebc4c47cdda9088ceb367151fb73436620523c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cdc880aea52274711dbe02e909d25a7900274b68a6030479527251b6f61c621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "870af56a210e8c10a34346398d62ca5784d79c983ce8be6425708a7ed93a632b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda879e2d4e1fc6def0f8aced8a32d35ae76545e53ed6e22bdb4ff9751777c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3727f75d9e56318e9c99ebeb87522ac8f9e3e7ad54c02f0236b9e6f0b89f40e9"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb7109e8862dab91274150b9b460a980580269fb6f6cd6a253b684c18bb52ab"
    sha256 cellar: :any_skip_relocation, monterey:       "13746d7bc0a31126f7c84bc76b9cd5edcc43bb7dcafe38ea2cef55c9e6aaadbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab7a31b3dc1027cb2915955d9c3813a282d3ae1cc744e112435bfe48df09382"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
