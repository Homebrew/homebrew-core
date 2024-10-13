class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.36.0.tar.gz"
  sha256 "bc2e2ff0268c2818659c524b21663564864b50ba102afb0a44fe73c08cf35ff0"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daffc9fddf61db76615594b339c75af67b27aa19ac493ec89caa63670814c59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a243c3fb66edb93ecce130aa181f0f043ce53fbbd62fad4c411ad44b4c13dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee47cc8f1a754e2a9cb4d80bb994169c83e6b76a383ad7168a1140c2601d6bba"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd70b7fd05413a03c6f8b261a50c2b568cd4704223a3b48d8ca7a240382179ad"
    sha256 cellar: :any_skip_relocation, ventura:       "08f7732ffbf8b73dd3ac5e0890519ae804e50a9255eba867109e7b4e2cc1b59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec873dd83d4db996a8784104d849fc3ca8596bada10186af21c1a3a1b1043cf5"
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
