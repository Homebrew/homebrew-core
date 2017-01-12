class Alacconvert < Formula
  desc "ALAC (Apple Lossless Audio Codec) encoder/decoder"
  homepage "https://macosforge.github.io/alac/"
  url "https://github.com/macosforge/alac.git",
    :revision => "c38887c5c5e64a4b31108733bd79ca9b2496d987"
  version "0.0.1"
  head "https://github.com/macosforge/alac.git"

  def install
    cd "convert-utility" do
      system "make"
      bin.install "alacconvert"
    end
  end

  test do
    sample = test_fixtures("test.wav")
    assert_equal "Input file: #{sample}\nOutput file: result.caf\n", shell_output("#{bin}/alacconvert #{sample} result.caf", 0)
  end
end
