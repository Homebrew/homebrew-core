class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.6.tar.gz"
  sha256 "ca552649f8282bca0dc53a9f841aefc556ae7351270db08f1e30bf0d3bfded7c"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1a695944920685ee43e74b1ce5656611ebb14527c1e1bb64a085a5a1806b4c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1a695944920685ee43e74b1ce5656611ebb14527c1e1bb64a085a5a1806b4c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a695944920685ee43e74b1ce5656611ebb14527c1e1bb64a085a5a1806b4c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d21cfcf0422e6c981f3c1313272de820132c159b01d92ae35b6925e8ac5687b7"
    sha256 cellar: :any_skip_relocation, ventura:        "d21cfcf0422e6c981f3c1313272de820132c159b01d92ae35b6925e8ac5687b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d21cfcf0422e6c981f3c1313272de820132c159b01d92ae35b6925e8ac5687b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d296cc2413573722ee9b80b384194472695141c4b0757f4205a3f7aa5f662e55"
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
