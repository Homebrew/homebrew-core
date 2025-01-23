class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.7.tar.gz"
  sha256 "5b8536b3738fb9a8dba9da9c27d9375761a98978dab9759eda0bf6b38b701121"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2307db2a92e53a034565c6e0415948f2140c419caf4998d2d0f34033d6df6475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ea6a54b0462050113ae17e3d52125138ba30b4f44b19026d2e45e6ed84ea8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea6a54b0462050113ae17e3d52125138ba30b4f44b19026d2e45e6ed84ea8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea6a54b0462050113ae17e3d52125138ba30b4f44b19026d2e45e6ed84ea8ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c18dfd2ca766f5ef8f571ce443bf6b0f9887684e176745e645c303f328788a8"
    sha256 cellar: :any_skip_relocation, ventura:        "9c18dfd2ca766f5ef8f571ce443bf6b0f9887684e176745e645c303f328788a8"
    sha256 cellar: :any_skip_relocation, monterey:       "9c18dfd2ca766f5ef8f571ce443bf6b0f9887684e176745e645c303f328788a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981e4d782de45f33801fc276cc3e7611f4e2d479ab99b1c0c5be6c46e353a7dc"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
