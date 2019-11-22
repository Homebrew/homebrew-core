class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libunwind/libunwind-35.3.tar.gz"
  sha256 "2bcc95553a44fa3edca41993ccfac65ba267830cb37c85dca760b34094722e56"

  bottle do
    cellar :any_skip_relocation
    sha256 "b406de81dd83a7d1ac2d3067829138f13374f023e8177782c84efc1c1f3f710d" => :catalina
    sha256 "fb467ee406b684f4d1cfe0e421b0b17d256bbec560fb74ae2c4f88d10e3a11b6" => :mojave
    sha256 "9ec7987285d9e911e70cc55d124d8462ab2987d0fe84ea4638188a7b14fea328" => :high_sierra
    sha256 "3dd8d375d7612f42e190cea3f67f6aab1f8d4fe03173ac6c49d8b1c9edb8bfc1" => :sierra
    sha256 "308e12c8084e3dd179e322320d45b7ebf3393b284cbb6a5754ccde9e577ad90e" => :el_capitan
    sha256 "0a920420880c1222c365fb886eaf0cbc215529e7a7be39280520dc770386fe75" => :yosemite
    sha256 "2b4ae1b1a438269ae833a52e73cafd6357b0d30dd5e8eb33ef29271cdc259f7c" => :mavericks
  end

  keg_only :provided_by_macos,
    "this formula includes official development headers not installed by Apple"

  def install
    include.install Dir["include/*"]
    (include/"libunwind").install Dir["src/*.h*"]
    (include/"libunwind/libunwind_priv.h").unlink
  end
end
