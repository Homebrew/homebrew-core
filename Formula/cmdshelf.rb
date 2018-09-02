class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.0.tar.gz"
  sha256 "3edb610cb512e147aa32e3e27e4c2d01a18ef738626304c42751c16a5b0fe309"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system "#{bin}/cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
