class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "f0bef60b67baf01e82300b72d84d8f0c08414d7c292bc4cd494cc8b1e735015d"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f08f3851f5558ff08affec6c4b17a3fba114922780cdc0b8438d12b7d7144d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f08f3851f5558ff08affec6c4b17a3fba114922780cdc0b8438d12b7d7144d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33f08f3851f5558ff08affec6c4b17a3fba114922780cdc0b8438d12b7d7144d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf8b55b257ad32f8e8459aa9aeb6672954ed250f58afaba3bde11992874703e"
    sha256 cellar: :any_skip_relocation, ventura:       "7cf8b55b257ad32f8e8459aa9aeb6672954ed250f58afaba3bde11992874703e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d2dc30b20db718f0531772e0b8008988912fff4af86a0d59dbff5d510a54e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f158801704a8750cbe7ba564aac630e9239d7ccb9f99f65d7bf95cff9d01d4af"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
