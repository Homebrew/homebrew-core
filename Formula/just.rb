class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.3.tar.gz"
  sha256 "e891be5cd7145e8d23875a3ea67d6ed5afd8c3006b31509ccdd4ea5e7f245f69"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ecfec3b30334b44afeaeed679e57b39aef1790e0670eea40b3407882522fbd6" => :mojave
    sha256 "db8cde2d97d907cf276d216cd878c385960dc06d2b8c04fa85e05b9cfd2e3482" => :high_sierra
    sha256 "c726429effc8e3147851ed252c9e1194284517b33d60644f5610d289b09455f9" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
