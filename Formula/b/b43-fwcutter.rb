class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-020.tar.xz"
  sha256 "bae58321c0926827b99afd4fddaebbc934c781d8e010fe62e1ddc4af83046214"
  license "BSD-2-Clause"

  livecheck do
    url "https://bues.ch/b43/fwcutter/"
    regex(/href=.*?b43-fwcutter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e5e81ff865b2905041a0fea85e776c1ee09b134c3ab75f1b875458be7bea210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b4f1d7cacb06e6e7de79de8013c0d5df2dd5c3edc79c4642d64d4f5d10a572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5324a1cf7a15dbdd27cb2635fc3b29334e532d6d97fecf4d4ee89941b598d950"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d48b82edbc8a9dabe2799c9f5fa6a1d45001658db8aa2c1a617b5080f026e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2c8d93464e6b0487659822b8593bceeb6abfa702bd684cc681139d23a2b914e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37b812c01e5e0ddedd9106aa5b18643da573d0ad4359ec8764806ec27a10094"
  end

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! "install -o 0 -g 0", "install"
      m.gsub! "install -d -o 0 -g 0", "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"b43-fwcutter", "--version"
  end
end
