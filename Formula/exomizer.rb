class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.0.1.zip"
  sha256 "82b68de9de4b9ac07599fcc961b401e6e545d1c6d6ac7fe564d29760b1008a78"

  bottle do
    cellar :any_skip_relocation
    sha256 "348d752fc662836e05ebf9aa25897af8fdca8e30a81681cd2cd93cfc4f8f4247" => :high_sierra
    sha256 "a060de86ab94057a86a4dbd95424b83399ea0c853341e18f80e3eef4ba3f70b8" => :sierra
    sha256 "e98170ffbf253e6509d42dc1a6c2ceeabbda462e306f69d8ff845e148c50905f" => :el_capitan
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
