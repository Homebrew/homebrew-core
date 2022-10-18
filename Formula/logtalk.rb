class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3590stable.tar.gz"
  version "3.59.0"
  sha256 "89aac05347d456712a670c5a8dacb4fbb51ec0ef16c5707c7384480aae01c721"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "912b934fd7343cc6582d080fd384000c30afe9271bf8b901cd47395a56658836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae687cd4b365750138aad012fa8ada1f8beb9cce59fce18562f3438521d074c6"
    sha256 cellar: :any_skip_relocation, monterey:       "42035cf1cc637f642a62c60c3478b586f402da779adbe699011fee57c57efbf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a64e64775041da200c166011770c328479aa16d2c578e476401147f744305b"
    sha256 cellar: :any_skip_relocation, catalina:       "a3bca481243f2daf1377cde3048e2f499db55b1cec5e027de4faa15772090bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789e8d88076b942f371a068a5c6e2e2d72f1c70108c41a939a802b8420e59cf4"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
