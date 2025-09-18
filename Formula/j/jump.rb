class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "ce297cada71e1dca33cd7759e55b28518d2bf317cdced1f3b3f79f40fa1958b5"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d618b1643851a787269a79deabe1e1085c058b1f1c7738169b8e8ed05b9acef6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecddcb16acf0ec0cfd882ba188e731b1a82afc22aa30131f15331ccea1135ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecddcb16acf0ec0cfd882ba188e731b1a82afc22aa30131f15331ccea1135ece"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecddcb16acf0ec0cfd882ba188e731b1a82afc22aa30131f15331ccea1135ece"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6bef70aca4c86f24e680096a7137ebba478b1420acca74e131987f3fdb2fc8"
    sha256 cellar: :any_skip_relocation, ventura:       "3a6bef70aca4c86f24e680096a7137ebba478b1420acca74e131987f3fdb2fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705352accfdad579ce325bda4651dc9190a67437b026fd20f07d67e9fa0a23fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db113fb8a6cb2652adb039f6cc0056341c95df09201ead5d5dd306e2c7f5921"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"jump", "shell")
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system bin/"jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
