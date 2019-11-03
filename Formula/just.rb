class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.5.tar.gz"
  sha256 "a444b7a28ad33c19113cbb76d6678ea966a64eebd366bc889fa83aa8a44abd65"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac9d587e99636143d02e857995b3ea447ac91a90f3aa3dfbec674ae6f448ffd6" => :catalina
    sha256 "4f4a4a269c1b250bf80358698be72ea2933184b9266854aba72753ed1f61a3d9" => :mojave
    sha256 "d91842885554056a0134764dd0a8d1d74150c35960469a44190d0c11cbac13ed" => :high_sierra
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
