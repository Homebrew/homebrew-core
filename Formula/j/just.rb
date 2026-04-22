class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.50.0.tar.gz"
  sha256 "cca015e07739a1c26c6fc459f7d46e1e36ce0f7613114eddedd8cd3af55a10b7"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04a8a7ee8bd490cdc7467127bb70520153e4a64df2544eadb46c0b40bbbbf5a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0366821df246e3badb4cf779ee56f69781d55fd5c6c33cdcda8275b868be6340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e428a2baf5cc8bf9ec8fbf90810908d2faf30aaab09c8ba9d34f40af6a57290"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb3af70271b782191016fa888c1563be65db37f065e9b9fa78f1ce4a3c0272b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40546fa0c9989f5bc9c96227fa9868f074dab4d9afc413ef9c44b2a33a520bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "718eec95679c80fcd1bf3842b1e705f84f1ee61cb4401f6648bbae284af637b8"
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
