class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.html"
  url "https://bues.ch/b43/fwcutter/b43-fwcutter-021.tar.xz"
  sha256 "c21e0ccf0d15e668ade31fe4d4c424ef6be006b85f63603b6f965f4c5a6f3121"
  license "BSD-2-Clause"

  livecheck do
    url "https://bues.ch/b43/fwcutter/"
    regex(/href=.*?b43-fwcutter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d3b3d9900452b2cb1f69d78cc5aee52e6d7a670846bd304f75b746c7f8fd42c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57b8e25d937753bafc32ac5d300ea0fdac6352bcb4216eb12e56ea651f603e66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "736cdf5c49916cf6889ca822ad79807073a7468d804e1e68f9a33aba018cf83b"
    sha256 cellar: :any,                 arm64_linux:       "8766b8be4ecaf144ddb009d11664236a185347b8d013748f190b77ac623c0b0f"
    sha256 cellar: :any,                 x86_64_linux:      "1a9d39f6f14afa678fc07affb74210ee13e65ce628a2430cf616c88716d32944"
  end

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! "install -o 0 -g 0", "install"
      m.gsub! "install -d -o 0 -g 0", "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
      # Prevent `make` from using SDK metadata as the source file
      m.gsub! "obj/%.o:", "obj/%.o: %.c"
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"b43-fwcutter", "--version"
  end
end
