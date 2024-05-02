class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https://github.com/supercilex/fuc"
  url "https://github.com/supercilex/fuc/archive/refs/tags/2.1.0.tar.gz"
  sha256 "44495207db38045f776db5b3d64872379d3b9ee64726a35bde730e5538003f96"
  license "Apache-2.0"
  head "https://github.com/supercilex/fuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dd9c791616c8eaac62b9fc7f9649570a3bad45e2bc63d627929b066ee5b325d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e33d622dab9b21e5dbbb223090fc0e0478747ddda8d036b159dcfd70abfbde6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a594340210168b1a494ac7075a5eba36a4b62daa5a11310fd0bd16ff63e6ab8"
    sha256 cellar: :any_skip_relocation, sonoma:         "11f6bfc41e312c7f3d3628d66cd37e518cfd5d974cb3d18f4d00ab17c0db2021"
    sha256 cellar: :any_skip_relocation, ventura:        "2b49b70ee8f59a457a33bfa08691524aef73f6c04cb07135ba41f2eab7a1a651"
    sha256 cellar: :any_skip_relocation, monterey:       "00c1f7219b3427e7c6b622d0caa66d1cfd63488606c892457cefb3ead7c106fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56e09cd3d14a1576990d1d71f85e13e6c280f131c69b5c58e28f0a98b19f8d7"
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
