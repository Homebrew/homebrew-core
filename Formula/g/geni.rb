class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "d0029ff1796d00619502eb72023e46be10bda6782b1d2f2f7566a99db851ddf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "082c05af650b22d45bcec097033f0c4fa054fb884383fc49b4be244134dcc18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e13e4b53ff54c78adb01cf283a3e92a6605f7586fda1dfe4e107036a5fba91a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1213730d2c20c860f627e5f5130755b786fa8d1b83265f0129c5052de823eebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb33eeefe31ce58446d7554142b41f5bd8700a2f94c2e4295456791ec9cf4db"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb58b1562f9cf35bfc80fdc39309d1380ffdbe71994de76ca6d953c42dd9d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "646a041d9e618cdcc1fccd264f8f5af7cae0a62d48596f8fb38680626231b623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4ece2f2a3c3c401ac2854782c7a13499efcfaa82e0d2d519c874e15d1ae1eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
