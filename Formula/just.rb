class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.4.tar.gz"
  sha256 "e319c4c26187eb6943dad5fdab3b919cab53e6dee054529f39974592ea032cec"

  bottle do
    cellar :any_skip_relocation
    sha256 "52373ae9135dac336161cce4676c360def86c551c3da068d786134b4d2b331d0" => :catalina
    sha256 "246ef70a47dc400b6ef7b2a290b2ab6ed655bfc84917b5b76287843668b23328" => :mojave
    sha256 "422a62ff2ffa9cfdea61a13f1962f12c072fcf44c99db067eef70dc2a82559a6" => :high_sierra
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
