class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3830stable.tar.gz"
  version "3.83.0"
  sha256 "afbdd7d3d104330249dfff74ae5d62d6320781293f862b04b53b5f22c1118792"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbeb818aea6dd679df5578a739645635f18538785dbb0ed63a2c9de4c8af7b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7848caec04435bb4c4a4b69f72d7d62441d50953a9a5beebdb005b6077bfa495"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e51d0569cc835a56951b695a7924d3f6efe6a5aede36eefd340f94eec4b48aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5faf3a028629ff15554c3679431e6817e6dca7303b17b76c5059851f6cd59b76"
    sha256 cellar: :any_skip_relocation, ventura:       "256183aece4974d8a727a38977f2d7122b270ecd850af067727dcbc92d35ea6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2185cfcbe12eda662b882e22c7f07796a58f64fc78c802b15ed8328163caf545"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
