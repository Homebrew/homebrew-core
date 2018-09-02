class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.0.tar.gz"
  sha256 "3edb610cb512e147aa32e3e27e4c2d01a18ef738626304c42751c16a5b0fe309"

  bottle do
    sha256 "f52956d5a64e1c9ac364b8186b83420e51faae062a4ce9a5dd9a4bb1a97fccb6" => :mojave
    sha256 "f166a78a1e54d46d12058b984580429500b282e3be4c0fd57af620c17cc3c0cd" => :high_sierra
    sha256 "26aa9a9c5adb85ae48b9fe841dd0fca5db78b1ee221bedae9333c1a44e5c1228" => :sierra
    sha256 "06d6a7d68886507cd82229a08e89bce1c0be508c472192f1fdd01c670037851a" => :el_capitan
  end

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
