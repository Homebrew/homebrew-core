class Horsegen < Formula
  desc "Diceware passphrase generator (Correct-Horse-Battery-Staple)"
  homepage "https://github.com/chr4/horsegen/"
  url "https://github.com/chr4/horsegen/archive/v0.3.1.tar.gz"
  sha256 "5909ad2ab125d77835c98c97829daba99c397eda1ea51ff5e489d0ae654413f8"
  license "GPL-3.0"
  head "https://github.com/chr4/horsegen.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\w+-\w+-\w+/, pipe_output("#{bin}/horsegen")
  end
end
