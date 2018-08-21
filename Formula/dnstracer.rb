class Dnstracer < Formula
  desc "Trace a chain of DNS servers to the source"
  homepage "https://www.mavetju.org/unix/dnstracer.php"
  url "https://www.mavetju.org/download/dnstracer-1.9.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dnstracer/dnstracer_1.9.orig.tar.gz"
  sha256 "2ebc08af9693ba2d9fa0628416f2d8319ca1627e41d64553875d605b352afe9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fceeded94f224e8204c253197d742e5d2f94a83684b5ca0613f50841bd0ebe6" => :mojave
    sha256 "29086b127a2967e8e481c60e397fe803165be2d1ad46be7176642567d8844cc0" => :high_sierra
    sha256 "4d89811df14c8564d1ad2dae5a2f45f5e11a51f7b7ecb5f75f692b9507451b7b" => :sierra
    sha256 "d90b34cfc2d03af3c80ef6118484ddff05863a0e4d9a7a5db8bcf3801bcb3414" => :el_capitan
    sha256 "13eaef32eb5d1dd11e71adeb6abe9bd43200a219951648d0d4eb707ea935c542" => :yosemite
    sha256 "d4b8c5352a711e86091779e6565f752828af549c5806fdf3d58cb572e977aaa4" => :mavericks
    sha256 "cb878a09be7de0d7a3e354c086a74d6de61b9e53f4ce499c931706f24598f3ae" => :mountain_lion
  end

  def install
    ENV.append "LDFLAGS", "-lresolv"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnstracer", "brew.sh"
  end
end
