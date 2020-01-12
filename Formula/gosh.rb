class Gosh < Formula
  desc "Do everything from the terminal"
  homepage "https://gosh-terminal.github.io/docs/"
  url "https://github.com/gosh-terminal/gosh/archive/v0.0.5.tar.gz"
  sha256 "d41f82f11d43c6c2b18592369e14aea59b24ce51b6720682632b7ba037118255"

  depends_on "go" => :build

  def install
    system "git", "clone", "https://github.com/gosh-terminal/gosh.git"
    Dir.chdir "gosh"
    system("go build -o gosh main.go")
    bin.install "gosh" => "#{bin}/gosh"
  end

  test do
    system "#{bin}/gosh"
  end
end
