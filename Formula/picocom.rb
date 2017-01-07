class Picocom < Formula
  desc "Minimal dump-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/2.2.tar.gz"
  sha256 "3e3904158d675541f0fcfdcd1f671b38445338f536080f5de8d6674b5f33d4ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "04be4265f5b4d5364d5b3dc9c312a8426fec03155f5eb3279e0546ce06013d0a" => :sierra
    sha256 "0f7f8d35db1ac8c7e96f7d985a06a05eb4930dab539ca278a2544ca3f0cb329c" => :el_capitan
    sha256 "57b523048108fb223498ad33e9d0f7ed0ca31038e5f4c64f341360b5ee24b5c2" => :yosemite
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
