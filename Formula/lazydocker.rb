class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.9.1",
      revision: "10617da5608990bf4911142745d31566bac6964a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a32a3111697ccba3b9f1d959f206c23a6b2fdc2fdb968f5eed12575c67e56b4" => :catalina
    sha256 "efe1cebae9966e4cbe0b55cfd28f6625d37b821827c7954168e80fc932ec57e2" => :mojave
    sha256 "79c56a22d891d09ce3b08ef1c400768dc68f2c5244b9a33070aae6f33e3d1e7b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
