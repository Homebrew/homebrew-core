class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      :tag      => "08",
      :revision => "49e4029728927afb1a22864698be10cf445413aa"
  head "https://repo.or.cz/neatvi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c839cf593245c6d026d4a547669c29978e3ec64ef9f247630e4d1183db1376f" => :catalina
    sha256 "12703985422c0a7dd73003a874c0ce747cf3fb3022f674cbb344e7a0d7836ce9" => :mojave
    sha256 "e7046e2ff2dbe83c98fa1ddf5c06f299ffc45f825c421fccb95b624d104eae3e" => :high_sierra
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
