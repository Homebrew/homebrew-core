class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.29.1.tar.gz"
  sha256 "3e909245038295b6935448d48bb93418b4bc1b0b5621116d1568e12dd872512b"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd44437fff26f440fc2e5f7943c7bfacf044905550fd9b8977cfe13eacec8f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b36fef1798e4a094b501b694c56cca8502f091cbd00b6334c45c05f9ec4f48a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc63fa55e222c3858e5ef48e03997ad401f7e5630e65cfd414bc5b25081edb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "da73738fc6735743dfac56b9adcd91f05d78f1350c3cb75d33e6cf2ddc24ba6e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d32648aaaef196124204cb9851f2597a4d8c1f54bcf80ffc48c75bb64096085"
    sha256 cellar: :any_skip_relocation, monterey:       "c49caca88b001d42ce5ecf32161ed292fe684c49eccaa874ecf13a4e02095c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c33d9a9ca3007423a003895f6549e4dc7fec3b39f672cc769b8133ac2a6afb"
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
