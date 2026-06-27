class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/libunwind/archive/refs/tags/libunwind-201.tar.gz"
  sha256 "bbe469bd8778ba5a3e420823b9bf96ae98757a250f198893dee4628e0a432899"
  license "APSL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "c577eb37a7a223cb6ace388cf86d3b3c436e41ca7d058d949458f0b204046a58"
  end

  keg_only :shadowed_by_macos, "macOS provides libunwind.dylib (but nothing else)"

  # Apple stopped using this repository in macOS 12.3.
  # https://github.com/apple-oss-distributions/distribution-macOS/commit/a2a84eee239e63427b9bc7e011eaaba8ab878fd3
  deprecate! date: "2026-05-17", because: :unmaintained
  disable! date: "2027-05-17", because: :unmaintained

  def install
    cd "libunwind" do
      include.install Dir["include/*"]
      (include/"libunwind").install Dir["src/*.h*"]
    end
  end
end
