class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.2.tar.gz"
  sha256 "40390b40ed03a7dca19f81b703b2098f7e1fb349491b7469e1a46f859f705eff"

  bottle do
    cellar :any_skip_relocation
    sha256 "081d5e949000ebf72fd66ab1cfdf52260294206efc7239fbb885c2f0f019210f" => :catalina
    sha256 "684bfd93f9681c99d9d43569f1e461055d603977e7637aac25f48e8be0a9e637" => :mojave
    sha256 "24f1ad29258a45f3ee3f29920c8d3f150acd556f76248349fd8ab886fc199789" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
