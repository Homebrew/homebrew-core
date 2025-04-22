class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "db50276b36a0b6f83abc77f59ca9470134ef6072986b440f5f352263afb4458e"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72378cd86fb4b44f6ba32ede5f4f31bd11ad52f11f1515e3db994db9b7f66ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72378cd86fb4b44f6ba32ede5f4f31bd11ad52f11f1515e3db994db9b7f66ff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72378cd86fb4b44f6ba32ede5f4f31bd11ad52f11f1515e3db994db9b7f66ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c16b0df1d4a70365a076fbcae25c2d8e7f1e278c134d9f04007dabe87fdd976"
    sha256 cellar: :any_skip_relocation, ventura:       "4c16b0df1d4a70365a076fbcae25c2d8e7f1e278c134d9f04007dabe87fdd976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e6f2287e2a6b7a4a567e9d150be472128108e5180d14592fc9b358346dd7f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
