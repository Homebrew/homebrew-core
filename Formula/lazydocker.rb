class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.8",
      :revision => "cea67bc570daaa757a886813ff3c2763189efef6"

  bottle do
    cellar :any_skip_relocation
    sha256 "024db9b510e170cb389420f3aadcaa9814b6e8580b84d63bcc9cb610c779773b" => :catalina
    sha256 "5a6a4732f4260c7ae53f1153772bd0d15a350142a7f15e9cfb0f2b99bcf69a7b" => :mojave
    sha256 "da3b8b84547a247bfe92c5b4e0741e7991ba1eba723b460ff097dce1652cf2ad" => :high_sierra
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
