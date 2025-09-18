class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "575207aad706ebdbbde648a6948f073a202bd4b5810031ceb3a7de5eeae938b0"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20c805ce43c3a22720e1fed1a8abf2341c144b60d1076f9d298cdcec2e52a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f08b63f2ed3f7b9f4a99edecd9afb3a38bddaba9aadee8050f13b8fff69994a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "437f1292938b070066bc61cb09e366140a49dee6e20d3fff785c8346572f1a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84655f5d92aeb6029bcf33e77e3d3eb3c36211ea437ba2ecde9a34da33fcab15"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d0fc91c589c4563032ac2692c0245d3613d0c4cf726f1c7976e75ee91e33742"
    sha256 cellar: :any_skip_relocation, ventura:       "3b3e958df29f9a83b2e1b479fedc3c63832f9e95a3acec10865438b0b1106c8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf517af832854720b7fcad7858559a7fc29f57cbcec78593e5908f0eb036d5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b0c2cbd89397241328ba0e34119adfeba97fe57a6e548d00dcf330de174f9f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
