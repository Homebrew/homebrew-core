class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.55.1.tar.gz"
  sha256 "40a2d3725480523ffebb762669cafe2b0135a00383946eec3d47adf5e9be6345"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca6cdb6b39637ef5ba71de828efd427e72d8303ad191aa3d75a5ead681521025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439409078e9e07056b3840d1fa31f417cad065852dc48391808d2f5b0bcdae89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8be682c78c457d2df04d745228f524a92902bf4ececded841849d7b302c210"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52fbb81662ab048c8ada62b928bfc198f83f1afce12b563785de78c4d928ac7"
    sha256 cellar: :any,                 arm64_linux:   "18659a840aae3fb17202c1cbf6adaf41a01aa7014055f63c8088c2de592214e1"
    sha256 cellar: :any,                 x86_64_linux:  "92623f98ad320beb2c72f6b577b2251ed7e6fa9facf880f87b4989c0c9dc0cb0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
