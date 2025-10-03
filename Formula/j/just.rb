class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.43.0.tar.gz"
  sha256 "03904d6380344dbe10e25f04cd1677b441b439940257d3cc9d8c5f09d91e3065"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec3adde551060ce714f685f23ead67766ff67fe45268b02c556e71819e1af89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66c169a5e4f9392bc4a4cde2b399adf3f5b35023f13a6244e74d8abb52fcd76f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f465def316e3de884b5dcc0576df0242f1a421e3ccb7fbd4e7d714368d6e1d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9f8001a964466313fc9fa0bb7221eacf0a0b42e9472886072ba8a218ddc0fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47e29c43c5fb61cf2127b20933f9d2834c125720aa37743ed5f019b0ab60862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b4d980ebbe3ab13c0b02faffed6a7779ec8f2855825e0a7e781b5358cc7233"
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
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
