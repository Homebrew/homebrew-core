class Anyshortcut < Formula
  desc "Launch your favorite website in Terminal blaze-fastly"
  homepage "https://anyshortcut.com"
  url "https://github.com/anyshortcut/anyshortcut-cli/archive/v0.2.0.tar.gz"
  sha256 "948c9a32dded1feaf31bf811b884b0702ea2876b0267194ca4c090341427dfe1"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/anyshortcut"
  end
end
