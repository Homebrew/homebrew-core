class Dum < Formula
  desc "Npm scripts runner written in Rust"
  homepage "https://github.com/egoist/dum"
  url "https://github.com/egoist/dum/archive/v0.1.8.tar.gz"
  sha256 "0c8337d79e0e331b2dbd14e615adc9d359d3491632e21d479a306c9a2845009c"
  license "MIT"
  head "https://github.com/egoist/dum.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write('{"scripts":{"test":"echo \"test\""}}')
    assert_match "test", shell_output("#{bin}/dum test")
  end
end
