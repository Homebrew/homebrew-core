class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.51.0.tar.gz"
  sha256 "ce297cada71e1dca33cd7759e55b28518d2bf317cdced1f3b3f79f40fa1958b5"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "987dfba1cccc632159347ae8150db80a7cd6456bea696cb3c15c3d8064ebc0bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987dfba1cccc632159347ae8150db80a7cd6456bea696cb3c15c3d8064ebc0bc"
    sha256 cellar: :any_skip_relocation, monterey:       "3c2fe9f884aa4752c8256358a0c444da6b22c3143eb1d5d361ab79271c90c650"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c2fe9f884aa4752c8256358a0c444da6b22c3143eb1d5d361ab79271c90c650"
    sha256 cellar: :any_skip_relocation, catalina:       "3c2fe9f884aa4752c8256358a0c444da6b22c3143eb1d5d361ab79271c90c650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad5a151b8c861fd49cdbfca4f0f9f9e844daab3f77515839df277039dfbc1e94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
