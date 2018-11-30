class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "https://boot-clj.com/"
  url "https://github.com/boot-clj/boot-bin/releases/download/2.7.2/boot.sh"
  sha256 "0ccd697f2027e7e1cd3be3d62721057cbc841585740d0aaa9fbb485d7b1f17c3"

  bottle :unneeded

  depends_on :java

  def install
    bin.install "boot.sh" => "boot"
  end

  test do
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
