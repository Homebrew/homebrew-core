class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/releases/download/v1.5.9/src-norm-1.5.9.tgz"
  sha256 "ef6d7bbb7b278584e057acefe3bc764d30122e83fa41d41d8211e39f25b6e3fa"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "a8b6f0061522bcf29d931c09c1b59ccaa2d80ae14567f7c5dd26daab0c4931bf"
    sha256 cellar: :any,                 arm64_sequoia:  "42f6765ea93269821c415353a75e0439c050430e10d633d259667834b9d00da2"
    sha256 cellar: :any,                 arm64_sonoma:   "f249073b0e73e8f75fb755ea727165947c1c6ebc36f306ea93651a0d16abc066"
    sha256 cellar: :any,                 arm64_ventura:  "429a634be03412ac1b594de81d880673e719228b75ceddb6040d530b641ea4c1"
    sha256 cellar: :any,                 arm64_monterey: "3576daa38873bc40a81217a11164103c894f8266703024105fa1d4855f4d77f2"
    sha256 cellar: :any,                 arm64_big_sur:  "4cee74c6a548d3ccc9905f2e48e66502f423a8e6d98501d31d1c5f0d621b2eb7"
    sha256 cellar: :any,                 sonoma:         "380a1a18e78e03b446d64a1dcf2d22c86bdf53fa0709a70fec0bd63c30d5f4a2"
    sha256 cellar: :any,                 ventura:        "58c3cff32396773d100d991713d86c88567d112bad44bf65cf2f499abbf7dace"
    sha256 cellar: :any,                 monterey:       "4461cfa3ac911780e417455ccd5ea1d040dfee539529a54b1d3a3e1a001fc73e"
    sha256 cellar: :any,                 big_sur:        "a4fe786c06af5a57a962e1e12aea4ed1c5b747d1f98b060c11df8377c2cdb63b"
    sha256 cellar: :any,                 catalina:       "d70d20d746ace62b26cb70f7d940a2cfb6705af64501e1b7f948c4ca3a8b5afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cc5db1902343405319417d14dd804b7c2662dbe6c6d488f643dd8ae45561a418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0749ed0f0382f434ebec2f77953464af8d80db63e8a36760013a32dffea3c501"
  end

  uses_from_macos "python" => :build

  # Fix warning: 'visibility' attribute ignored [-Wignored-attributes]
  # Remove in the next release
  #
  # Ref https://github.com/USNavalResearchLaboratory/norm/pull/27
  patch do
    url "https://github.com/USNavalResearchLaboratory/norm/commit/476b8bb7eba5a9ad02e094de4dce05a06584f5a0.patch?full_index=1"
    sha256 "08f7cc7002dc1afe6834ec60d4fea5c591f88902d1e76c8c32854a732072ea56"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "install"

    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    C
    system ENV.cxx, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
