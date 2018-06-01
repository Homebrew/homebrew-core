class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.0.0.zip"
  sha256 "89b7c4167de44d6e76954979c0d86a565a26d84da37c4769d083d3c3b44c1a62"

  bottle do
    cellar :any_skip_relocation
    sha256 "33cc7dc3c832788cc4d61a9853f55e320468928310acf54994680427408b6ee3" => :high_sierra
    sha256 "45731b31fed3a6ffa3d0bc0dac41e9eda993a1d1bdf9d0409bf41523b8f426c1" => :sierra
    sha256 "87dc2aec228936922e108a428f3e788906cd2cfdaf99910a6366de13514c63a4" => :el_capitan
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
