class Fex < Formula
  desc "Powerful field extraction tool"
  homepage "https://www.semicomplete.com/projects/fex/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/semicomplete/fex-2.0.0.tar.gz"
  sha256 "03043c8eac74f43173068a2e693b6f73d5b45f453a063e6da11f34455d0e374e"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "176a130c8c8b14eee48303c89fcab8d8dd6534e43fb042d8fab5b30486e2641b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d0777ac160fda3d6860d6a7077e98e05e0a7a80f75c4c15e39c58699bd9c22ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0265e802a5e8b6d206890f636723f6ba34c0da506b1de7b47f84208d8d93f278"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1baf47daa289d9a7d09cfdb695a4a1a51841458d992bbadc68a27780f81d7182"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ee2c09154b30ee5c0ec51ee562d4efc6528e1d69761810cb1eae30fec98bea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb8ef2d1b057c6cc2c462f6398911d8f55a85398b6eaf60f26c01a7cb3f87e04"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1a79707cd908a1c0999a22e7b817a57be8ed07c7eab273a4c26e5785a5988cf"
    sha256 cellar: :any_skip_relocation, ventura:        "ba9dc477aa675909383c9bbda166b0786254fea4898afa1c46c6b85a3400d11f"
    sha256 cellar: :any_skip_relocation, monterey:       "c227531dc137d14bcfefc19b9a385d5ae842e5f89b1e1b2e75b969b18786c522"
    sha256 cellar: :any_skip_relocation, big_sur:        "48289f9a071052a99a7ff520feb793abe0cfd3c81b939bf767cc3bb51ac09918"
    sha256 cellar: :any_skip_relocation, catalina:       "ddc12a1eefc9238e48ba57f00694e6b01cdce2ef41bcf34ddfd405696d3a7a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "106493be88cc6c2467a1bf144a6bb3bf49779831d4c7577046a864d09adc6db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ec5c054bfa085ae8e70f521aa235ddae7a2a481f4b9512751490c8a5166c09"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fex 1", "foo bar", 0).chomp
  end
end
