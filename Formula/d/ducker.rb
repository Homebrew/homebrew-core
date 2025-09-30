class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "d27122cbf4942fa649c804ed0b202210be5ba330087352d167d9bcb433031986"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96ef688f1183b543156dcaf17bdee602dcfef5e12aab6d2ccab9819b74e8e1a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f7e9337edb56f88f1d79bdf759d492b9ce63c22e52d0bb074a9857259f9b56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62101d63233506cc123865e32780984093da91e1716317d91b509590d0ef7f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "b35543d8133f439bb62147b0ecdd4d9eb719db8b90ea7495e6e10b2cced0d597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c064f2ba51b1b625dd1603aff6e69aed982b7c359e586cbd0cb076392b37a3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664f0fb4e27307c138993ddbb2f68717dd92d5e93d14d86388968cab08f797d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
