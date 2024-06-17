class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3800stable.tar.gz"
  version "3.80.0"
  sha256 "5eb8d220b3fa18866fabd28b854579bf56f06c2874ffe2eb3e9598c94ba1101c"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817cb9d5d9d6386daee5155c27e26ccfadab157d350ea7611edde900f9864931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ff76715fb8e5b7113f3f43f8e5c69ca84ad1e45eb2852d230947d2dafb4318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e417051dc891f453002cd816adf9b0d41606163c48dbaf53fb0a271f51a2b24"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b2f6024678a6b183ee14706098e4573fc738b5c2cca23d344005d9bbc49cb4e"
    sha256 cellar: :any_skip_relocation, ventura:        "c09756b6d35083f4794576706476f84e231e0253a32c30339084690c501f6c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "eef6dc89e0443abf841dfb455593c1cc1f1da68b6eb0049e7c25729eeed9362c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76916511b9b4a6512140e466603489eae6a3419f94bc5dff99eafa41c91a713"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
