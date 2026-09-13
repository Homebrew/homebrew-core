class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 3

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "16494c7f2dc00b76f48cfe4eecedf6654b105125cc15aa79ae74215958bf2d5b"
    sha256 arm64_tahoe:       "f2dcd176ebd262e64584de8180f9c58f3f2e9442014645582ce9bea729eff649"
    sha256 arm64_sequoia:     "b1b54bf47bdd2cff1696b3a96b48ba922df129e3d2541a11107a1fd040ca4536"
    sha256 arm64_linux:       "e83bfa5cd9f2669132caa35ce32f4b2da3dc31ffb04f480e66f816ae0295c1af"
    sha256 x86_64_linux:      "5ab53d6f72128b8c9cfb0e85e7e0859e0f4e1b16c9cd06d2ddf246ffe0088288"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix build with Crystal 1.21
  patch do
    url "https://github.com/crystal-community/icr/commit/bebf21ccea7c372b86d233552b05b824b21e97f7.patch?full_index=1"
    sha256 "50b632eb3115eaa10b92b99df1cac9cdfbf4c2523204bd22b6a8c590f8204427"
    type :unofficial
    resolves "https://github.com/crystal-community/icr/pull/136"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
