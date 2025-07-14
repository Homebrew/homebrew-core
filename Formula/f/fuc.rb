class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/3.1.0.tar.gz"
  sha256 "cfc1faaec08e7b2a5aec124abea12a8779cf7c2da937931964112210d2bdb576"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810b9cc7306a29745fee1872c9c80e73742c3b60c0b531c013f7ab8595e2d4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fddcc8458d803967ea2ff40ef526c7d158191a1e87880802adae9f1fc718781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "415675ed993272e495d29db7a3a0dc4c4a1cadf06b10a9e75e5112f6649ac1b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa0c61c6aac2e948e7af5fb193f1d5f8ecf827c23f534567038417fa07d2bec"
    sha256 cellar: :any_skip_relocation, ventura:       "8ae9b57a91d98cbf5d74baa27e4088ad44e967ecada4c69aa2d845563f91d583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4693df723b5361b59492ab40ddf8836056b4d0f29ec11e38916f9904f07e77ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ca42aa37ebdff82a4c971357affe30656b4909ef0eb59bfaf87a68afa7c5b5"
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
