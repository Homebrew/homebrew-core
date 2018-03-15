class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-2.0.10.zip"
  sha256 "74afb08a51466e24e5e95b8672c9a152a1ab4eb31464f29cd630c1feb585b027"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cbcc0d2b3c2f10d98b8fe778723a1e2cfc68324b672df819f968080f71dce63" => :high_sierra
    sha256 "a5ab7a5a4c509713c1c2648bae73aa2ee9eced90197d0ab615247c10acfd0895" => :sierra
    sha256 "62e6ad8ec5fb1e980950be6d40e61640319a94d750a104e0d91f6e913b25ce5e" => :el_capitan
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[exobasic exomizer]
    end
  end

  test do
    output = shell_output(bin/"exomizer -v")
    assert_match version.to_s, output
  end
end
