class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1285.19.tar.gz"
  sha256 "6f8671e2bdeed7545b454909b97dafcb5b5bc3f5bf0e715d9bdee79d9adabdcb"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc98ed0ceecac54e52f03e92dd6e037191e8a5686730e32ce04987025536b614"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
