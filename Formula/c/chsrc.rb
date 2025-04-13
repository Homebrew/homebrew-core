class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0f44119b8ecb58166913ddabced4f1e8143e283d142f6198482042582ba914f8"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359ffd13818c49d1bc3abbb8653d30111b31b183bd0282fd7c23d43d05408434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0700b46bc8aa46cdd21674f47be66a1a7b1c15536cdd6fa678a0ac08b812c4b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc3e7e0fd869be0b80bf330500a82b4dab8146b978006af00f9c0b43fff2103"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d95d65e5b8951e1447c5ab9d588923466f96ac97808a68664e54833b76f6a5a"
    sha256 cellar: :any_skip_relocation, ventura:       "899dee75126247dbe76e0d7b06d1ebf7046802083c882833356f8c9f1d917911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ce1b538e0b95536a90cf0b1537239fe16dbc74994d4f5310a8c1d316eca0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be0c8102ea86fb2ed74a87e3c006974cb7beb76ab94b5436c06f2aec974ca66"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
