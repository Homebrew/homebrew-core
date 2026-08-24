class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "03c84d1d30bce73f2fcbfa79c8df51e580293918fef9c35966b158eaae234a08"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28cef94d64d123003d870720448134cc3a4470a7cbad936eb64f5b0c3486961f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a4dca114674d1b064f394bf26efb806d61b37539d814bbe3d7a6763e4b8486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4283c9eb362dc0b749c84d10347540284ca73b47860e41dd25e24bd162e9d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c20aeb802a37e05a8052833a49314593ff1e9dbfab59cf6c0907c6a827d22fdb"
    sha256 cellar: :any,                 arm64_linux:   "2ba0977ea32eb5215ce174167dfac7e288a7808b95da9f4b641fcd3c437e4061"
    sha256 cellar: :any,                 x86_64_linux:  "76fc2b049f4eda64626052c3be6ed5ebe73168d1f2e448f2a461dfe02fa9e094"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~NBT
      print("pi = {pi}")
    NBT

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
