class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 4

  bottle do
    sha256 arm64_golden_gate: "c21cafe1f6624e3f664638d863f7f4b4ec2f34bf25bd16362f0dcf116f3e47b3"
    sha256 arm64_tahoe:       "0eeb299f632e4352bc1de10ab2f57eadd1fa6cfecc457aee62308bac6aac52c2"
    sha256 arm64_sequoia:     "05b06f5e34378d1371b8679250de08974be0bf4c90040c127a602b79719e18c7"
    sha256 arm64_linux:       "cf3adb692ca9244a7ea72337c0af1044c55fea5a462a4d3fb7b5365dde76aaef"
    sha256 x86_64_linux:      "2801f28b1a6d6886ce3ce140914c3da162908c9c04175952c076f8f9435daccf"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libyaml"
  depends_on "openssl@4"
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
