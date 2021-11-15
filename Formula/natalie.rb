class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.7.0.tar.gz"
  sha256 "f7959915595495ce922b2b6987368118fa28ba7d13ac3961fd513ec8dfdb21c8"
  license "MIT"
  revision 1
  head "https://github.com/krzyzanowskim/Natalie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149e46b9c1fd6dc56e855583824fc194f68f6c910b671bebe4fa68ac43915041"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7c39d8bcb8d60b095d9b9b90207042791d994f22a53c97e709aa16768a9b28"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb0e910fe6f93ec2a190e3a36e51baa2550bd08c64a83ebd6f8d9ca78296510"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e745ce1d0a34e0887319f32d39ae10e7ae34475fcb9a54916569f7672074b22"
    sha256 cellar: :any_skip_relocation, catalina:       "218ec8bb0ac3ac4de7a6fa8489f3ad7013b1beb051a7c0e74a6e37ade79eee6c"
    sha256 cellar: :any_skip_relocation, mojave:         "9dcc093fc648175eb165aec20413246ace7427d0d3c4a9884d37cfad9a851dca"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dd51e00a1969ffdd478e954bed48bedd1c5a9813b67931aa146711f49cb58223"
  end

  deprecate! date: "2020-09-08", because: :repo_archived

  depends_on xcode: ["9.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = shell_output("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end
