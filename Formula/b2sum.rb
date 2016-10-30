class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/20160619.tar.gz"
  sha256 "cbac833ccae56b5c6173dbeaf871aa99b32745cf7a994c7451d4533ecda55633"

  bottle do
    cellar :any_skip_relocation
    sha256 "26e11b434c3416172d848b237f67ca5e171c7c11188a5f86c83a5d54a53a8a3f" => :sierra
    sha256 "ff4a36110ddee427728c3c7027b6e64d4ecdcab4bbe73bf69cf200cbfd877657" => :el_capitan
    sha256 "ac07e18f25467617297e60a4a46d2309241ecf16adc642d8ef0abfbd6dd2cd70" => :yosemite
    sha256 "d2adbbbe2cce0efe380586ebbfd6a765fdc092c9d205134119613b0dbf9964ab" => :mavericks
  end

  def install
    cd "b2sum" do
      system "make", "NO_OPENMP=1"
      system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
    end
  end

  test do
    assert_equal "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923  -",
                 pipe_output("#{bin}/b2sum -", "abc").chomp
  end
end
