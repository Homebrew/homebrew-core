class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/1.1.8.tar.gz"
  sha256 "8fa22647b9a8939e18884325a0d5640cfe5a88ea33bbb14781a2135b5464f465"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c62dc6576956a318cadfb0849d76c652f82c044ea8cfba1fab60c17b7dd0d585"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b248f35f59d0c954feab59736b481748552de0f5f89cf6fc560bd9bb60d1308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105d8dcf18c49756ea340addd634a72381c5b36de126c830da88c94330bff485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c19feeb89a2c5756614923fe926669dfb79147ffb208ac26baa5ccbe2d12099e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecac33683a84954f1b7b5c3bc591d72c3b67809ee7286306ddf5485d95a27dff"
    sha256 cellar: :any_skip_relocation, ventura:        "0d17b6170728ad23f74d04c1b0f8ea04175d1ea9b93b53bbb89aa8e09bbcf53e"
    sha256 cellar: :any_skip_relocation, monterey:       "e44e5a84d93ddf2a85db34956697a2f6c99677bd8c212405300b35d0fdf7c699"
    sha256 cellar: :any_skip_relocation, big_sur:        "824ab6e950f2ea20343e5656f9d630f07b0b69767aa45d01d00cef29461e2afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e7cde0e8e0a4617f86d8b02aca4a504309c490159a49412d70870979e02092c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin/"cpz", test_fixtures("test.png"), testpath/"test.png"
    system bin/"rmz", testpath/"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}/cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}/rmz --version")
  end
end
