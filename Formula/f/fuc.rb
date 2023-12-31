class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/1.1.10.tar.gz"
  sha256 "64bc306aaed95eae23c9be7e55a2ddff0128e5702b7c46e1f90f6ba88c64456c"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f3007c575c0585ffb69d3e9d46efecd2950b2dee5c287b6dd8933a492edfeb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955b320e9aa8424a12ccea4ef1fbe426155c485ca2f58980bbf5e03965151848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4557725ee05e7685cf314b832e5452f4992a9b565f8cea53ce8f39235397b8c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4514da4eaa604760a41993b0044f5c44b89e761104139a677ccf3213a5dbcc47"
    sha256 cellar: :any_skip_relocation, ventura:        "a5b49973ef6cb63685e0213279eab2e80163b3c1fbbbcc505e5daca4829227c1"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1d0e9d3ddd1b77642ab99115fe416a56db2ca33bf9db723f6f04017f859f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38f91275d9388ad4dad02d891ddec5baeebcb853b0c92e8e64fe8a7c5286d29"
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
