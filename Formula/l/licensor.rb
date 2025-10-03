class Licensor < Formula
  desc "Write licenses to stdout"
  homepage "https://github.com/raftario/licensor"
  url "https://github.com/raftario/licensor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d061ce9fd26d58b0c6ababa7acdaf35222a4407f0b5ea9c4b78f6835527611fd"
  license "MIT"
  head "https://github.com/raftario/licensor.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b7072a1c2d29961fce1e5293dbd58ec4868d7bfa912647dd6373b89b2aceaeb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac1e3430727502de790d4320731f6108f02d5514a81e9577f963ce4f8294d39c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71b1af76e7d61bd12f4386ea45b16998895aba60a4b3a2ed0403fc2d25b569e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f184aff71bc45ecea1244c55c2f7f01271ac80a46942a3e60f176d0e86ec36f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e6fbe393ce18e98a319aedae21997dce223fc2979deb761d97ce4437f77b7e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ad74bf60d659d3523554d44db1ab486d0eee708d13bea561afff99f167a6e46"
    sha256 cellar: :any_skip_relocation, sonoma:         "edca5ae2dce5225627989bf5e5ac16b479e2332974ece8ce413e23c6982eb49e"
    sha256 cellar: :any_skip_relocation, ventura:        "b3f3ac98e20289e69e860ca0b4508c126dda52be3facc3810177cdaf2b82fff1"
    sha256 cellar: :any_skip_relocation, monterey:       "3603cf3a10496131f6cdff4987b18c336b9c7b34afec1e31d722d34a58aa9187"
    sha256 cellar: :any_skip_relocation, big_sur:        "167b3b40cc8af7b009ef8e9e61d886dd3bc356e3197c6672cf4d59edc0bbe6db"
    sha256 cellar: :any_skip_relocation, catalina:       "4c7e0923605a57a9e9855f0d3f30d695af99f87baf1eb5e216797ba7f9760845"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e1056cd569d727dd376987b9dba21aa0d108a4db550d7a88b2db93a87b72d2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd9933ef3863a349b7e364bcd9e135606d0b7468d2fe7402c3c688a8b3afd4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/licensor --version")

    assert_match "MIT License", shell_output("#{bin}/licensor MIT")
    assert_match "Bobby Tables", shell_output("#{bin}/licensor MIT 'Bobby Tables'")
  end
end
