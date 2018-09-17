class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.1.tar.gz"
  sha256 "e3f3934ce4d90183b3caac1e35eb584848588450694c494a89d6585685842407"

  bottle do
    sha256 "89d91fc1b52b9eba5d184713d1b9d7e732e7514be8255263a1b04fdaa064a3e6" => :mojave
    sha256 "08cc63b65230834d2a2ed4280c9245dcd0009d906d135ad91fe603fd8009e8e4" => :high_sierra
    sha256 "816b6386a012be243dd4d987e3204444e29f4eef0bf1077ba634c53748a2afd3" => :sierra
    sha256 "f9629700f2de22a4cc47e7fcb990de68839ce5e62bb59d7f12432836faa156fb" => :el_capitan
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
