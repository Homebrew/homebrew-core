class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/2.0.0.tar.gz"
  sha256 "0c41d4ed48048bbc998aebc76fc361ddad33fbb2004990d4125f5017a8660595"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "275410014572cbff3660a7d736ed728b6591083aaaf178e639ed15b88dde43c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90178d051a2f2830efbc250e6256f28e830769c5d0494989557f96e12cf09366"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9111501426163babdd1403e8304724ec3e5dec4eefaa70ae80109ef965f95bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5af79433022765aae02f242f278e54c3e6a7c9404b562f7ac381c6b774f1f9c"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f8c6f95719a6ded2b733030ae9ec08898d5fe7760c17cb038ad2a9033e325e"
    sha256 cellar: :any_skip_relocation, monterey:       "8c594bb00820af4db121a3b5a51019bdcee5688c3f89ae2ae0c237137d073145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f32f50eb06757ae47d20984d80a198fc4171fc7d04b2362c3e68f178dbb340b"
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
