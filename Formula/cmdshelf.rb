class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf 📚"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.0.tar.gz"
  sha256 "3edb610cb512e147aa32e3e27e4c2d01a18ef738626304c42751c16a5b0fe309"
  head "https://github.com/toshi0383/cmdshef.git"

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man.install "docs/man"
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    assert_equal "2.0.0", shell_output("#{bin}/cmdshelf --version").chomp
  end
end
