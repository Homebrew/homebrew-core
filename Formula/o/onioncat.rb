class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://github.com/rahra/onioncat"
  url "https://github.com/rahra/onioncat/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "75ff9eed332e97a9efb7999bbe48867d00e06ac20601cc72b87897d5b1859f99"
  license "GPL-3.0-only"
  head "https://github.com/rahra/onioncat.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "376be0d8ae8f091f6f6dae5beba524fd5ba07e2606264a73c1b827e187dc3ea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "29b153e2b454faccfb935cf8524b3b37fafb5b17a86ba38377d887ca0bbd86a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58d3c104e6597baefa21599dead5423ea1a7be37f40ca84d398c1f39458db474"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313d9bc109a8fdd7f9ceb5995e359e071e6ea822f4f20a550b6c84687e638894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c8dba362799a9d9646efb169e854dc964dd0f76c3837a746f074a436e0f6b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7b14ce567dc873d3caae2039c68b510c0311698e5d8cc89e62cd4b46d9f3258"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3f88f8aa7942ec817d17c5d9f6807f3bdaa98c82bdabb281e865b26100df878"
    sha256 cellar: :any_skip_relocation, ventura:        "03dbf70b4079c360e0fe10e7909068bf277be34b9780402faf525697b7b7cfb0"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf2a843df22a579b0965685c779df4165d0db2be9ffeeef32e2769136fd0cb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3be4e31eed45930e85c8043abf03fc34ebc668bc5f9e2d8b09c4dfec8ae6090"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "33f731f9fc0cb8ede749dd65d70b62581f80f59305a9bef7613ff69e8a2807c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7909dd65c46856bf1ba00a9253d6b51cd4c1b23b2595a57d0018607ca02bd94"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tor"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end
