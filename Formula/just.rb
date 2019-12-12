class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.3.tar.gz"
  sha256 "f86fc0fb522d45afdb09703c44071ef3f5740de5fcf65f3fd93415b27bc4625c"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcea6bb0ea83088ffe3f758ba978ff09499d5e1469b566ed1a131b23eb052b36" => :catalina
    sha256 "b3b342e6c87f58bfae94f32e1c52b1a056704ac73522176ac42f763233ff26a6" => :mojave
    sha256 "f99d67edfe383f354f99e0898e6975c21ba395140be8b1ac82ec7ced8cdb6361" => :high_sierra
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
