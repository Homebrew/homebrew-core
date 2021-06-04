class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.0.2.zip"
  sha256 "cf94a2d9e66c104489846bb703c497aab8146ac4a54964def01692d418b16075"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "3c8e7724f8ff5820c2233f91797f34333a9eefcb9c1520db2dcffb4a05cea833"
    sha256 cellar: :any_skip_relocation, catalina:    "b298240aec4d77e212b57666ef51ca125127da3ac5185166c6c96495e217358c"
    sha256 cellar: :any_skip_relocation, mojave:      "653ce86b30882fae1deae16bbf40b50f9b46b7f4f3f51e1952a988121e4fd5dc"
    sha256 cellar: :any_skip_relocation, high_sierra: "46b2f9b190847344ab7a16c94eb4b2bad48009a8f08e5463427af75c9eb67409"
    sha256 cellar: :any_skip_relocation, sierra:      "6c6389b18ce3be2c7ffdb919e79273ecc8e26b9067bd06b29474d37c9e162e83"
  end

  # custom license
  disable! date: "2020-12-24", because: "custom license"

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
