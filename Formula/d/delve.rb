class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.21.1.tar.gz"
  sha256 "21dd0c98e101cd102e51ffa708d3f7d6dd32c2069b7d18bbcc35272c04dc822d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "271bf28768d20a139087e5abbf9e0b28821c74d2bd3946506e8b6316a6caafc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc206c1f49822b9ea08caadb80c39d22c0dba9a2b5890c5636921c83166cd399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cbf2d47f1d444215fd066a95855816f5a9592506ed57684f122a4b4e159f5a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1aa43f39446a77a5560d6c826c5e2309daa238395f2f5accc7ec42c0bc465804"
    sha256 cellar: :any_skip_relocation, ventura:        "75eb4e37227628fe3d714b78c66cc1bd71da1b186001dd97367af4975d5895ec"
    sha256 cellar: :any_skip_relocation, monterey:       "c4aad0e9e25842c347aa547b48231ddf14c194dfd5e80f79fa89b63009f124b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bedfb85b59011fcbb533ccb4bc25d91714f97c627ee7183f8e1b3146e14fa61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
