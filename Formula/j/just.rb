class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.40.0.tar.gz"
  sha256 "e0d48dcc7a086c5746b7f281a40e615c290cddf9c06134198c703dff2f62c1c4"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a6b6b8404100d3132208479921a4ed09c8def48bde2b738c93ca8eaadd54830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51dd382131ac203f0031498dd5ebabe6fc54efeba7df046695beac6a716c145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df2df15534cc802e940b5afe8cf8aadfd6e3c92bae5d6efd1126a6c5a2143c88"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d5f3f11e49b4db8a2e5e716dfa932f891bbbb186c38dfd3e295f1f9b7deb15"
    sha256 cellar: :any_skip_relocation, ventura:       "07a909e8ef87bd072a539a478dc9e29ae920e5883fe7a468ed415c573837f066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf41ddbe82dba608da75e9f3c87c13dfac9f6e0fbfc524ee7e256e73eb9454f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72485691bcbe738efc4a6c7928230bced747df97fdd6327dbeac65524dfccfcc"
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
