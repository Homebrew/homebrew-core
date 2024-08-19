class Fastfec < Formula
  desc "Extremely fast FEC filing parser written in C"
  homepage "https://www.washingtonpost.com/fastfec/"
  # Check whether PCRE linking issue is fixed in Zig at version bump.
  url "https://github.com/washingtonpost/FastFEC/archive/refs/tags/0.2.0.tar.gz"
  sha256 "d983cf9e7272700fc24642118759d6ab4185fca74b193851fa6a21e3c73964ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03c0f738cdb3df4339b9b2d3b23cc26f7822be6c13db12f2a514bc46d55b3892"
    sha256 cellar: :any,                 arm64_ventura:  "c4d87cb24608f3fd1b0f31264e2161f77aa238fca88653fed5047fb813ebcdc5"
    sha256 cellar: :any,                 arm64_monterey: "bdadc2b206dc4ea94adbf30b6ce1dc41b6491af2b98781222056bc1fe0931aac"
    sha256 cellar: :any,                 sonoma:         "89c081d16fcb8be8b1c39ddef7dfeac4ce7b226db72579ab59bc87f11326839c"
    sha256 cellar: :any,                 ventura:        "3ccdf0685ecc6553e6c1c01356b82e9713b4dd0dc6634e7862afddd088a840c4"
    sha256 cellar: :any,                 monterey:       "ab1b085557839ed4b19cc49d839b025ce2bb4fd9a474140121b153b0ca63aff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf228d820220f1c3499eced326d33d6492bcb86745db6aaaef29e41e8405f01f"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build

  on_macos do
    # Zig attempts to link with `libpcre.a` on Linux.
    # This fails because it was not compiled with `-fPIC`.
    # Use Homebrew PCRE on Linux when upstream resolves
    #   https://github.com/ziglang/zig/issues/14111
    # Don't forget to update the `install` method.
    depends_on "pcre" # PCRE2 issue: https://github.com/washingtonpost/FastFEC/issues/57
  end

  def install
    # Set `vendored-pcre` to `false` unconditionally when `pcre` linkage is fixed upstream.
    system "zig", "build", "-Dvendored-pcre=#{OS.linux?}"
    bin.install "zig-out/bin/fastfec"
    lib.install "zig-out/lib/#{shared_library("libfastfec")}"
  end

  test do
    resource "homebrew-13360" do
      url "https://docquery.fec.gov/dcdev/posted/13360.fec"
      sha256 "b7e86309f26af66e21b28aec7bd0f7844d798b621eefa0f7601805681334e04c"
    end

    testpath.install resource("homebrew-13360")
    system bin/"fastfec", "--no-stdin", "13360.fec"
    %w[F3XA header SA11A1 SA17 SB23 SB29].each do |name|
      assert_path_exists testpath/"output/13360/#{name}.csv"
    end
  end
end
