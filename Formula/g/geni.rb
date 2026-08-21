class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "4b12e63bf71e283381d923f108f1a48e52fe7e16ffcb21a082d2deb89e74e023"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7507ca58394b9a0e014e3323d773b358aab04c262c39a6ea599a539606b2b1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb0295124e7ae440c6bbc75b6a262d843c2f71fa3b33987b085a069440a2c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2798f5808f864aba80bb68e79e07533f09d054a746dfa102cdc536a49c2ad2c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e65489dbe80063cd87240ac08824e653120e8e7e053f9ac3daef3e8c06116298"
    sha256 cellar: :any,                 arm64_linux:   "c5aaabdd9522376af256a022020b1a27df4db219ca19157743241d1340d222db"
    sha256 cellar: :any,                 x86_64_linux:  "08599be811efc494b33ea7a712da82fa949f10a2d2c56bff7309afb11b76fcf6"
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
