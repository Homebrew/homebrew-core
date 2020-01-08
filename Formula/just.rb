class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.4.tar.gz"
  sha256 "e319c4c26187eb6943dad5fdab3b919cab53e6dee054529f39974592ea032cec"

  bottle do
    cellar :any_skip_relocation
    sha256 "5218ef7f8f317f541772103d10629911bb34123e52a5745acea38744163545ce" => :catalina
    sha256 "02f9d0cfad91974586b28e6d92505f1cc076f015b6136506669e355471843e90" => :mojave
    sha256 "9a0ef806b9fd2f0ea6f7c73cd767f233d259a750ca4179a92f5d02a7a7514c41" => :high_sierra
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
