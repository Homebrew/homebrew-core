class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/2.2.0.tar.gz"
  sha256 "d0444f67311408ecbcc51a8df120e711c2736a3b82186f33e5df7b12a6b9fc88"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcd1d2922b54e610b0307245102b426524c126e59cb7845168495567de4bdd53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265f6c4b3c90a69d2f4839c4b3223e938921d2c20cd06eeeb9dc738d10be302c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "766b2b0925f9f93750d977c09438af59e0e4faaa2840d6727d847d3968c6cc79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfc07b522a722f500bb4a41a807b0d60d9703fa91d28744164162b7b099d9e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "75f4a615ae85a48bd6ff73c4962c866b83f435437ac3b4d0f32076560c01ac03"
    sha256 cellar: :any_skip_relocation, ventura:        "416f1afd8d7468c5482f3828914d1346258f87f4c28dfb65030c397fc512a5de"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dfa350655fa9c2b05b5b2a0e53113e9b47d01b61b0178cba6f7efa6dd7d3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f339a5f0293554b86e38603fda5bec910cdb1a0ebb4adf791946b978e91bef6"
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
