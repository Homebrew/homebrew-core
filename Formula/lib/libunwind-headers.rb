class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/libunwind/archive/refs/tags/libunwind-201.tar.gz"
  sha256 "bbe469bd8778ba5a3e420823b9bf96ae98757a250f198893dee4628e0a432899"
  license "APSL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "24ed849a21c0cb1b8eda429fb00a9c9ecdc2483195d84de351f5806071ce19fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddc5b02449351bb8ddc11fea2d25ca79ecf87657dde6c7cd7c15f1b5d6ff17c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc5b02449351bb8ddc11fea2d25ca79ecf87657dde6c7cd7c15f1b5d6ff17c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc5b02449351bb8ddc11fea2d25ca79ecf87657dde6c7cd7c15f1b5d6ff17c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2493e296e5824c2caf88be9f46d111ca2b6691d6e459826f67f29498bb1bc3b2"
    sha256 cellar: :any_skip_relocation, ventura:        "2493e296e5824c2caf88be9f46d111ca2b6691d6e459826f67f29498bb1bc3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc5b02449351bb8ddc11fea2d25ca79ecf87657dde6c7cd7c15f1b5d6ff17c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc5b02449351bb8ddc11fea2d25ca79ecf87657dde6c7cd7c15f1b5d6ff17c5"
  end

  keg_only :shadowed_by_macos, "macOS provides libunwind.dylib (but nothing else)"

  def install
    cd "libunwind" do
      include.install Dir["include/*"]
      (include/"libunwind").install Dir["src/*.h*"]
    end
  end
end
