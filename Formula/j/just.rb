class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.38.0.tar.gz"
  sha256 "3d47e27755d39f40e1ca34bc0ef535fa514e7ed547b2af62311dcadd8bd6d564"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7105d991eee61b2ba03090f6324356f1ed9dc0aa9f093402c7fd8eaa4287fd1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3f21a3ccedbef806eae7111a8d7f90a8be2c83455d98c6ffbdc2328655678a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25d8d9ae6f0fab4760bd8c2e1dbb732cdc881222d0cd52014ba6e9313d39ce9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5cafdecf7bb541e47cabb82436f8067a7c0eb6dc83625ba929aa8822328cf4"
    sha256 cellar: :any_skip_relocation, ventura:       "daed72125fd53bef76a3b278f192fbf70814806c732e0519e232696203f7425c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3a2b92f0bd2fe5d2ddb0b40d6f11d8e37876504d061cba3e2e539a43328c48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
