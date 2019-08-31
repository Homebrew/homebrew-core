class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.12.0.tar.gz"
  sha256 "7a3d0d94b6bffa00644a4afbc5952f87965f4723de3878b97ef8b7ebfd912477"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a71e9fb381211afc6f4b6abbf6444ac3966808b97a7c4a4dd884c0fbf615f28" => :mojave
    sha256 "1591c3cceb6dfb4849558a8cbedb2cbfb08e66a67f567e5f9285bc4273b43ca6" => :high_sierra
    sha256 "b7cda190b1d08d0482c612200c48a402993fd79d4c1c56037161799d4b982912" => :sierra
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
    fish_completion.install "assets/completions/bat.fish"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
