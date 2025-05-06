class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6df48d339f9ae010ceaee04ad3f1f37a516f3923117c350b9483f816c5e982c3"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "150e62a7f0c85b0e9fb659c2ad255b8809c0316fdbc09d5f3428a9727273302f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac13250fa529d9dbe9ccfae5db396fb6cffe02cdd7c425c1ce98727f9f590be2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f13cae51ae4d01d23a9c1cc98e591d6b29c7f17f22dd8f653d949a9cacc1ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "936efa0aa8238b756850af7097aff6b85ba6377051f7fe71402176fc6f4bafc4"
    sha256 cellar: :any_skip_relocation, ventura:       "5856abff3cfdb55eff80d5119ee553c5a63992731e84fdace4f3de7793de46d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431171720c7256b4496ec99493fc93e472a12453e599543c25031b18205c4f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df822e6c1e7117c289b43e0ca9a93174d0637fe7d884d55bfc17b377c52adc32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
